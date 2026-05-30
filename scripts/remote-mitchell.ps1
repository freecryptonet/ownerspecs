<#
  remote-mitchell.ps1 — drive & extract data from the dealer Mitchell1 (TechAdvisor)
  running inside the secured "Remote Connector" (connect.exe / RemoteConnector.exe).

  WHY THIS EXISTS
  ----------------
  The dealer programs run inside a heavily-secured remote desktop where nothing can
  be installed. But three local channels are open and need no install in the secured
  box (capture/keys/clipboard all happen on the LOCAL PC against the connector window):
    * SEE     — CopyFromScreen of the connector window's bounds renders the remote
                Mitchell1 screen legibly (the window is NOT capture-protected).
    * CONTROL — keybd_event / mouse_event are forwarded into the remote session.
    * EXTRACT — Ctrl+A + Ctrl+C inside the remote app puts the EXACT text on the
                local clipboard (clipboard redirection is enabled on this connector).
  Verified working 2026-05-30 against account "APSA Mexico".

  USAGE
  -----
    powershell -ExecutionPolicy Bypass -File remote-mitchell.ps1 -Action find
    powershell ... -Action shot  -Path C:\Temp\m.png        # capture window -> PNG
    powershell ... -Action region -X 350 -Y 180 -W 560 -H 320 # native sub-rect crop (read tiny targets)
    powershell ... -Action click -X 180 -Y 226              # click (window-relative)
    powershell ... -Action type  -Text "2014"               # type literal text
    powershell ... -Action key   -Keys "ctrl+a"             # send a key combo
    powershell ... -Action copy                              # Ctrl+A+Ctrl+C -> stdout (exact text)
    powershell ... -Action clear                             # Ctrl+A + Delete (clear a field)

  The window is located by title/process each run (its HWND changes between sessions).

  GOTCHA (fixed 2026-05-30): the window-handle var must NOT be named $h — PowerShell
  variables are case-INSENSITIVE, so $h collides with the -H (region height) param and
  silently clobbers it with the HWND. Handle var is therefore $hwnd. Don't reintroduce $h.
#>
param(
  [ValidateSet('find','shot','region','click','type','key','keybd','copy','clear','scroll','windows','keepalive','ocr','clicktext')]
  [string]$Action = 'find',
  [string]$Path,
  [int]$X,
  [int]$Y,
  [int]$W = 400,       # region width  (Action=region)
  [int]$H = 120,       # region height (Action=region)
  [int]$Amount = -3,   # scroll notches: negative = down, positive = up
  [int]$Minutes = 10,  # keepalive duration (Action=keepalive)
  [int]$Every = 15,    # keepalive interval in seconds (Action=keepalive)
  [string]$Text,
  [string]$Keys,
  [string]$WindowTitle = 'Remote Connector'
)

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class RM {
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h,int n);
  [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int x,int y);
  [DllImport("user32.dll")] public static extern void mouse_event(uint f,uint x,uint y,int d,IntPtr e);
  [DllImport("user32.dll")] public static extern void keybd_event(byte vk, byte sc, uint f, IntPtr e);
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left, Top, Right, Bottom; }
}
"@

function Get-RmWindow {
  # Default targets the launcher ('Remote Connector' / process 'connect'). Pass a different
  # -WindowTitle to target a LAUNCHED RemoteApp window (e.g. 'HaynesPro') via -like match —
  # required to DRIVE launched apps (so Focus-Rm foregrounds the APP, not the launcher; otherwise
  # the launched RemoteApp gets no input and idle-times-out / signs out).
  if ($WindowTitle -and $WindowTitle -ne 'Remote Connector') {
    $p = Get-Process | Where-Object { $_.MainWindowHandle -ne 0 -and $_.MainWindowTitle -like "*$WindowTitle*" } | Select-Object -First 1
    if (-not $p) { throw "No window matching title '*$WindowTitle*'. Run -Action windows to list candidates." }
    return $p.MainWindowHandle
  }
  $p = Get-Process | Where-Object { $_.MainWindowHandle -ne 0 -and ($_.MainWindowTitle -eq $WindowTitle -or $_.Name -eq 'connect') } | Select-Object -First 1
  if (-not $p) { throw "Remote Connector window not found (title '$WindowTitle' / process 'connect'). Is the remote desktop open?" }
  return $p.MainWindowHandle
}

function Focus-Rm($h) {
  if ([RM]::IsIconic($h)) { [RM]::ShowWindow($h,9) | Out-Null; Start-Sleep -Milliseconds 400 }
  [RM]::SetForegroundWindow($h) | Out-Null
  Start-Sleep -Milliseconds 500
}

function Get-Rect($h) { $r = New-Object RM+RECT; [void][RM]::GetWindowRect($h,[ref]$r); return $r }

# keybd_event helpers
$VK = @{ ctrl=0x11; alt=0x12; shift=0x10; a=0x41; c=0x43; del=0x2E; backspace=0x08; enter=0x0D; tab=0x09; esc=0x1B; end=0x23; home=0x24; pgdn=0x22; pgup=0x21 }
# Extended keys (Del/Home/End/PgUp/PgDn/arrows/Ins) need KEYEVENTF_EXTENDEDKEY to register over RDP.
$EXT = @(0x2E,0x23,0x24,0x22,0x21,0x25,0x26,0x27,0x28,0x2D)
$KEYUP = 0x2; $KEYEXT = 0x1
function Send-Key([string]$combo) {
  $parts = $combo.ToLower().Split('+')
  $codes = @()
  foreach ($p in $parts) { if ($VK.ContainsKey($p)) { $codes += [byte]$VK[$p] } }
  foreach ($c in $codes) { $f = 0; if ($EXT -contains [int]$c) { $f = $KEYEXT }; [RM]::keybd_event($c,0,$f,[IntPtr]::Zero); Start-Sleep -Milliseconds 50 }
  for ($i=$codes.Count-1; $i -ge 0; $i--) { $c=$codes[$i]; $f = $KEYUP; if ($EXT -contains [int]$c) { $f = $f -bor $KEYEXT }; [RM]::keybd_event($c,0,$f,[IntPtr]::Zero); Start-Sleep -Milliseconds 50 }
  Start-Sleep -Milliseconds 150
}

function Capture-Rm($hwnd,$path) {
  Add-Type -AssemblyName System.Windows.Forms,System.Drawing
  $r = Get-Rect $hwnd
  $w = $r.Right-$r.Left; $ht = $r.Bottom-$r.Top
  $bmp = New-Object System.Drawing.Bitmap $w,$ht
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.CopyFromScreen($r.Left,$r.Top,0,0,(New-Object System.Drawing.Size($w,$ht)))
  $bmp.Save($path,[System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
  return "$path ($w x $ht @ $($r.Left),$($r.Top))"
}

if ($Action -eq 'windows') {
  # List all top-level windows with titles (find the launched RemoteApp's exact title).
  (Get-Process | Where-Object { $_.MainWindowHandle -ne 0 -and $_.MainWindowTitle } |
    Sort-Object Name | Format-Table Id,Name,MainWindowTitle -Auto | Out-String).Trim()
  exit 0
}

# Windows built-in OCR (no external install). Returns words + bounding-box CENTRES (image px).
# Used for DETERMINISTIC click targeting — find a label's exact pixel centre instead of eyeballing.
function Ocr-Png($path) {
  Add-Type -AssemblyName System.Runtime.WindowsRuntime | Out-Null
  $asTask = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object {
    $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and
    $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
  $aw = { param($op,$t) $asTask.MakeGenericMethod($t).Invoke($null,@($op)).GetAwaiter().GetResult() }
  [Windows.Storage.StorageFile,Windows.Storage,ContentType=WindowsRuntime] | Out-Null
  [Windows.Graphics.Imaging.BitmapDecoder,Windows.Graphics.Imaging,ContentType=WindowsRuntime] | Out-Null
  [Windows.Media.Ocr.OcrEngine,Windows.Media.Ocr,ContentType=WindowsRuntime] | Out-Null
  $file = & $aw ([Windows.Storage.StorageFile]::GetFileFromPathAsync($path)) ([Windows.Storage.StorageFile])
  $st   = & $aw ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
  $dec  = & $aw ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($st)) ([Windows.Graphics.Imaging.BitmapDecoder])
  $bmp  = & $aw ($dec.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
  $eng  = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
  if (-not $eng) { throw "no OCR engine for user profile languages" }
  $res  = & $aw ($eng.RecognizeAsync($bmp)) ([Windows.Media.Ocr.OcrResult])
  $out = @()
  foreach ($l in $res.Lines) { foreach ($w in $l.Words) { $r = $w.BoundingRect
    $out += [pscustomobject]@{ Text=$w.Text; CX=[int]($r.X+$r.Width/2); CY=[int]($r.Y+$r.Height/2) } } }
  return $out
}

$hwnd = Get-RmWindow

switch ($Action) {
  'find'  { $r = Get-Rect $hwnd; "HWND=$hwnd  rect=$($r.Left),$($r.Top)  size=$(($r.Right-$r.Left))x$(($r.Bottom-$r.Top))" }
  'shot'  { Focus-Rm $hwnd; if (-not $Path) { $Path = Join-Path $env:TEMP 'remote_mitchell.png' }; Capture-Rm $hwnd $Path }
  'region' {
    # Capture a SUB-RECTANGLE (window-relative X,Y,W,H) at native resolution.
    # Key technique for reading tiny targets when the remote view renders small —
    # a 400x120 crop is far more legible than a downscaled 1920x1080 full shot.
    Add-Type -AssemblyName System.Windows.Forms,System.Drawing
    $r = Get-Rect $hwnd
    $sx = $r.Left + $X; $sy = $r.Top + $Y
    if (-not $Path) { $Path = Join-Path $env:TEMP 'remote_region.png' }
    [int]$ww = $W; [int]$hh = $H
    if ($ww -le 0) { $ww = 400 }; if ($hh -le 0) { $hh = 120 }
    $bmp = New-Object System.Drawing.Bitmap -ArgumentList $ww, $hh
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($sx, $sy, 0, 0, (New-Object System.Drawing.Size($ww, $hh)))
    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
    "$Path ($W x $H @ window-rel $X,$Y -> screen $sx,$sy)"
  }
  'click' {
    Focus-Rm $hwnd; $r = Get-Rect $hwnd
    $sx = $r.Left + $X; $sy = $r.Top + $Y
    [RM]::SetCursorPos($sx,$sy); Start-Sleep -Milliseconds 200
    [RM]::mouse_event(0x2,0,0,0,[IntPtr]::Zero); [RM]::mouse_event(0x4,0,0,0,[IntPtr]::Zero)
    "clicked $sx,$sy"
  }
  'type'  { Focus-Rm $hwnd; Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait($Text); "typed: $Text" }
  'key'   { Focus-Rm $hwnd; Send-Key $Keys; "sent: $Keys" }
  'copy'  {
    Focus-Rm $hwnd
    Set-Clipboard -Value ([guid]::Empty.ToString())  # sentinel so we can tell if copy landed
    Send-Key 'ctrl+a'; Send-Key 'ctrl+c'; Start-Sleep -Milliseconds 600
    # Clipboard redirection over RDP can briefly lock the clipboard — retry the read.
    $r = $null
    for ($i=0; $i -lt 12 -and [string]::IsNullOrEmpty($r); $i++) {
      try { $r = Get-Clipboard -Raw -ErrorAction Stop } catch { Start-Sleep -Milliseconds 300 }
    }
    $r
  }
  'clear' { Focus-Rm $hwnd; Send-Key 'ctrl+a'; Send-Key 'del'; "cleared field" }
  'ocr' {
    # OCR the window; print each word + its SCREEN-coord centre. Filter with -Text (-like).
    $p = Join-Path $env:TEMP 'remote_ocr.png'; Capture-Rm $hwnd $p | Out-Null
    $r = Get-Rect $hwnd
    Ocr-Png $p | Where-Object { -not $Text -or $_.Text -like "*$Text*" } |
      ForEach-Object { "{0,-26} x={1,5} y={2,5}" -f $_.Text, ($r.Left+$_.CX), ($r.Top+$_.CY) }
  }
  'clicktext' {
    # DETERMINISTIC click: OCR the window, find first word -like -Text, click its exact centre.
    $p = Join-Path $env:TEMP 'remote_ocr.png'; Capture-Rm $hwnd $p | Out-Null
    $r = Get-Rect $hwnd
    $hit = Ocr-Png $p | Where-Object { $_.Text -like "*$Text*" } | Select-Object -First 1
    if (-not $hit) { "clicktext: '$Text' NOT found on screen"; exit 1 }
    $sx = $r.Left + $hit.CX; $sy = $r.Top + $hit.CY
    Focus-Rm $hwnd
    [RM]::SetCursorPos($sx,$sy); Start-Sleep -Milliseconds 200
    [RM]::mouse_event(0x2,0,0,0,[IntPtr]::Zero); [RM]::mouse_event(0x4,0,0,0,[IntPtr]::Zero)
    "clicktext: clicked '$($hit.Text)' at $sx,$sy"
  }
  'keepalive' {
    # Defeat the kiosk idle-timeout WITHOUT keyboard side-effects. Earlier a Shift-tap
    # keep-alive triggered Windows "Sticky Keys" (Shift x5) — DON'T use keys. Instead jiggle
    # the mouse a couple px over the connector window every -Every seconds for -Minutes min.
    # Movement is forwarded to the RDP session (resets idle) with NO focus-steal, NO keypress,
    # NO click — so it won't disturb HaynesPro state or trigger the re-scale toggle.
    # Run with run_in_background so the session stays alive during agent read/reason latency.
    $r = Get-Rect $hwnd
    $cx = $r.Left + 8; $cy = $r.Top + 8   # neutral corner; no clickable target there
    $end = (Get-Date).AddMinutes($Minutes); $n = 0
    while ((Get-Date) -lt $end) {
      try { [RM]::SetCursorPos($cx,$cy); [RM]::mouse_event(0x1,0,0,0,[IntPtr]::Zero)
            Start-Sleep -Milliseconds 40; [RM]::SetCursorPos($cx+3,$cy+3); $n++ } catch {}
      Start-Sleep -Seconds $Every
    }
    "keepalive: $n mouse-jiggles over $Minutes min (every $Every s)"
  }
  'scroll' {
    Focus-Rm $hwnd; $r = Get-Rect $hwnd
    $sx = $r.Left + $X; $sy = $r.Top + $Y
    [RM]::SetCursorPos($sx,$sy); Start-Sleep -Milliseconds 200
    $delta = if ($Amount -lt 0) { -120 } else { 120 }
    for ($i=0; $i -lt [Math]::Abs($Amount); $i++) {
      [RM]::mouse_event(0x800,0,0,$delta,[IntPtr]::Zero); Start-Sleep -Milliseconds 90
    }
    "scrolled $Amount notch(es) at $sx,$sy"
  }
}
