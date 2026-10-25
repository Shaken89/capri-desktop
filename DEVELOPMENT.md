# Capri Enhanced development

Work is on feature/capri-enhanced. The configured origin is Shaken89/capri-desktop;
existing application links reference lachydotmcg/capri-desktop. No push is performed.
Account ownership cannot be independently authenticated from a Git remote alone.

## Windows build

Install .NET Framework 4.8 developer tools on Windows, then from a PowerShell terminal:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build.ps1
```

The script compiles the existing WinForms sources with the Framework compiler,
embeds the original sprite strips, icon and font, and produces out/Capri.exe.
It also compiles and runs tests/PolicyTests.cs. GitHub Actions runs the same script
on windows-latest. It does not publish binaries or create a release.
To test the newly compiled app on an interactive Windows desktop:

```powershell
$p = Start-Process ./out/Capri.exe -ArgumentList '--smoke-test', "$PWD/out/smoke" -Wait -PassThru
if ($p.ExitCode -ne 0) { throw 'Smoke test failed; inspect out/smoke' }
```

Inspect the current smoke output, test multi-monitor dragging, display removal,
negative-coordinate screens, DPI changes, voice/chat, and hit testing. CI does
not substitute for these interactive checks. Never execute downloaded releases
as part of validation.

## Architecture and behavior

AnimationState and AnimationPolicy centralize animation identity, looping versus
completion rules, seated transitions and frame-independent easing. Existing Play,
Advance, blink overlays and speech mouth animation remain in Companion to preserve
interaction behavior. This is an incremental extraction, not a complete controller
rewrite. Cursor reactions are bounded to a nearby pointer and enabled explicitly
through the tray menu. They run on the existing visible animation loop; no new
monitoring thread is created. Smooth motion is optional; 30 FPS remains the default.
Both settings persist with the existing preferences. Original sprite frames and
artwork remain unchanged. Rendering reuses its bitmap, reallocating only on resize.
New characters appear on the cursor's monitor; saved positions still use existing
working-area clamping. Display-change callbacks guard disposed/uncreated forms.

Services/CompanionServices.cs (located at app/CompanionServices.cs) defines future
cancellable language-model (including Ollama adapters), speech, conversation-memory,
desktop-awareness and narrowly typed interaction contracts. DesktopPermissionGate
fails closed without a prompt and requests consent per operation. These are extension
contracts, not implemented adapters or an enforcement layer around existing features.
Future desktop providers must call the gate before accessing the desktop. Memory
storage, retention controls and adapters are future work. No screen capture or command
execution is introduced.

## Validation and distribution

Linux checks: git diff --check; all 13 sprite resources present; tracked artwork,
website and Worker files unchanged. C# compiler, PowerShell and Windows runtime are
absent in this instance: compilation and policy/desktop tests have NOT run here.
The Windows workflow has not been submitted or executed yet.

No repository-wide license was found. The included font has its own OFL notice;
that does not grant redistribution rights to application code or Capri artwork.
Obtain applicable permissions before public distribution. No release is prepared.
