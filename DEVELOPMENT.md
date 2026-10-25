# Capri Enhanced development

Branch: feature/capri-enhanced. Origin: Shaken89/capri-desktop.
No upstream modification, push, or release publication is performed.

## Build and test

Install .NET SDK 8 and the .NET Framework 4.8 targeting pack on Windows.
From the repository run `./scripts/build.ps1` in PowerShell, or:

```
dotnet build app/Capri.csproj -c Release -o out
dotnet run --project tests/PolicyTests.csproj -c Release
```

Output: out/Capri.exe. All original sprite strips, icon and font are embedded.
The application continues targeting .NET Framework 4.8/WinForms; the core test
runner targets .NET 8 so it can run on Linux. No UI framework migration occurred.
Build uses NuGet's Microsoft .NET Framework reference assemblies on Linux.

Run only the newly compiled executable on an interactive Windows desktop:

```powershell
$p = Start-Process ./out/Capri.exe -ArgumentList '--smoke-test', "$PWD/out/smoke" -Wait -PassThru
if ($p.ExitCode -ne 0) { throw 'Smoke test failed; inspect out/smoke' }
```

GitHub Actions builds the checked-out event revision on windows-latest and runs
core tests. A seven-day downloadable development artifact is uploaded only for
private repositories because artwork redistribution rights remain unresolved.
No push has been made, so this workflow has not run. On a public repository use
the local build instructions; public binary distribution requires rights review.

## Available behavior

Right-click Capri to enable Explore window edges. It is off by default and
requires Idle motion and Sit on windows. Every 25 seconds, an eligible seated
character takes a four-second walk using the existing perched sprite fallback.
If not seated, she tries to drop to a reachable surface. User interaction, chat,
sleep, dragging, cursor riding and menus interrupt exploration. There is a
20-second cooldown after interruption. Movement reverses at an edge and respects
screen bounds. No new sprite artwork or walk cycle is claimed.

Hop on this edge initiates a gravity-based hop on the current support. This is a
vertical hop, not window-to-window pathfinding. Existing drop/landing logic is
retained. A disappearing/minimized support now initiates falling, and moving
landing targets are revalidated. Fractional motion is retained between frames,
avoiding integer rounding bias. Cursor riding now uses elapsed-time easing.

Tray settings persist autonomous behavior, exploration speed (25/50/90 px/s),
gravity (6/11/16 times character size), fullscreen pause, and Eco (15 FPS).
Balanced remains 30 FPS; Smooth motion provides up to 60 FPS. Eco takes precedence.
Fullscreen pause is opt-in, hides companion overlays and suspends render updates;
a low-rate foreground check restores them when fullscreen ends. User-hidden
state is preserved. Detection reads window geometry, not application contents.

## Service boundaries

AnimationState/AnimationPolicy retain the previous animation transition extraction.
MotionPhysics contains portable gravity, acceleration/friction, crossing and
fullscreen geometry functions. DesktopBehavior owns decision cooldowns, movement
state and fractional horizontal displacement. Companion integrates these with
existing Ledges window filtering, surfaces, support tracking and layered rendering.
Ledges continues its original polling implementation; WinEvent-based invalidation
and more complete locomotion/social hierarchy remain future work.

The earlier CompanionServices interfaces remain extension contracts, not new AI
providers. Existing Brain/Agent/Voice chat features are preserved. This pass does
not claim Milestones B–D: streaming Ollama settings, local voice, persistent memory,
vision and permission-controlled desktop tools remain to implement and validate.
No new screen capture, microphone recording, command execution or telemetry is added.

## Validation and remaining acceptance work

Linux: core tests execute animation timing, exponential easing, exact gravity at
different frame rates, ballistic hop, acceleration, collision direction,
negative-monitor fullscreen geometry, cooldowns, interruption and default-denied
permissions. The actual application cross-compiles against net48 references.
Compiler emits 38 CS0649 warnings for existing deserialization DTO fields.
Compilation is not proof of Windows runtime compatibility.

Windows still required: original smoke suite; move/resize/minimize/close support
windows during walking, hopping and falling; negative-coordinate monitors; mixed
DPI; monitor removal; fullscreen entry/exit; input hit testing; serialized setting
round trips; existing voice/chat behavior; CPU/memory measurements at each FPS.
No original installer or downloaded Capri binary is executed.

This is an incremental Milestone A implementation, not complete Enhanced 2.0.
Remaining A work includes jumps between windows, event-driven window caches,
direction-aware artwork, transition blending and a complete hierarchical state
machine. Complete Windows acceptance before building later milestones on top.

## Sprite pipeline and rights

Keep PNG strips in assets/sprites with existing frame order and dimensions.
Clip defines frame count, FPS and height; resource names are Capri.Sprite.<name>.png.
The SDK project embeds strips automatically. New animation identities must be
registered in AnimationState and mapped explicitly in Clip, with policy tests for
looping and completion. Reuse a documented existing animation when artwork is absent.

No repository-wide license was found. Font assets include an OFL notice; this does
not grant redistribution rights to application source or Capri artwork. Preserve
notices and obtain applicable permission before public distribution.
