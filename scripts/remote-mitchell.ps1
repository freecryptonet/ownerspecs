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
    powershell ... -Action click -X 180 -Y 226              # click (window-relative)
    powershell ... -Action type  -Text "2014"               # type literal text
    powershell ... -Action key   -Keys "ctrl+a"             # send a key combo
    powershell ... -Action copy                              # Ctrl+A+Ctrl+C -> stdout (exact text)
    powershell ... -Action clear                             # Ctrl+A + Delete (clear a field)

  The window is located by title/process each run (its HWND changes between sessions).
#>
param(
  [ValidateSet('find','shot','region','click','type','key','keybd','copy','clear','scroll')]
  [string]$Action = 'find',
  [string]$Path,
  [int]$X,
  [int]$Y,
  [int]$W = 400,       # region width  (Action=region)
  [int]$H = 120,       # region height (Action=region)
  [int]$Amount = -3,   # scroll notches: negative = down, positive = up
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

function Capture-Rm($h,$path) {
  Add-Type -AssemblyName System.Windows.Forms,System.Drawing
  $r = Get-Rect $h
  $w = $r.Right-$r.Left; $ht = $r.Bottom-$r.Top
  $bmp = New-Object System.Drawing.Bitmap $w,$ht
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.CopyFromScreen($r.Left,$r.Top,0,0,(New-Object System.Drawing.Size($w,$ht)))
  $bmp.Save($path,[System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
  return "$path ($w x $ht @ $($r.Left),$($r.Top))"
}

$h = Get-RmWindow

switch ($Action) {
  'find'  { $r = Get-Rect $h; "HWND=$h  rect=$($r.Left),$($r.Top)  size=$(($r.Right-$r.Left))x$(($r.Bottom-$r.Top))" }
  'shot'  { Focus-Rm $h; if (-not $Path) { $Path = Join-Path $env:TEMP 'remote_mitchell.png' }; Capture-Rm $h $Path }
  'region' {
    # Capture a SUB-RECTANGLE (window-relative X,Y,W,H) at native resolution.
    # Key technique for reading tiny targets when the remote view renders small —
    # a 400x120 crop is far more legible than a downscaled 1920x1080 full shot.
    Add-Type -AssemblyName System.Windows.Forms,System.Drawing
    $r = Get-Rect $h
    $sx = $r.Left + $X; $sy = $r.Top + $Y
    if (-not $Path) { $Path = Join-Path $env:TEMP 'remote_region.png' }
    $bmp = New-Object System.Drawing.Bitmap $W, $H
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($sx, $sy, 0, 0, (New-Object System.Drawing.Size($W, $H)))
    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
    "$Path ($W x $H @ window-rel $X,$Y -> screen $sx,$sy)"
  }
  'click' {
    Focus-Rm $h; $r = Get-Rect $h
    $sx = $r.Left + $X; $sy = $r.Top + $Y
    [RM]::SetCursorPos($sx,$sy); Start-Sleep -Milliseconds 200
    [RM]::mouse_event(0x2,0,0,0,[IntPtr]::Zero); [RM]::mouse_event(0x4,0,0,0,[IntPtr]::Zero)
    "clicked $sx,$sy"
  }
  'type'  { Focus-Rm $h; Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait($Text); "typed: $Text" }
  'key'   { Focus-Rm $h; Send-Key $Keys; "sent: $Keys" }
  'copy'  {
    Focus-Rm $h
    Set-Clipboard -Value ([guid]::Empty.ToString())  # sentinel so we can tell if copy landed
    Send-Key 'ctrl+a'; Send-Key 'ctrl+c'; Start-Sleep -Milliseconds 600
    # Clipboard redirection over RDP can briefly lock the clipboard — retry the read.
    $r = $null
    for ($i=0; $i -lt 12 -and [string]::IsNullOrEmpty($r); $i++) {
      try { $r = Get-Clipboard -Raw -ErrorAction Stop } catch { Start-Sleep -Milliseconds 300 }
    }
    $r
  }
  'clear' { Focus-Rm $h; Send-Key 'ctrl+a'; Send-Key 'del'; "cleared field" }
  'scroll' {
    Focus-Rm $h; $r = Get-Rect $h
    $sx = $r.Left + $X; $sy = $r.Top + $Y
    [RM]::SetCursorPos($sx,$sy); Start-Sleep -Milliseconds 200
    $delta = if ($Amount -lt 0) { -120 } else { 120 }
    for ($i=0; $i -lt [Math]::Abs($Amount); $i++) {
      [RM]::mouse_event(0x800,0,0,$delta,[IntPtr]::Zero); Start-Sleep -Milliseconds 90
    }
    "scrolled $Amount notch(es) at $sx,$sy"
  }
}
