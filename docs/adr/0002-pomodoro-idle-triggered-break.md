# Pomodoro: idle detection backdates the break instead of starting it fresh

When work ends, the "Start Break" popup blocks until clicked. If you've actually stepped away from the computer, you never click it — the popup just sits there while overtime piles up, and clicking it later starts a fresh break even though you already rested.

We detect Away (≥5min with no input, via `xprintidle`) only during `awaiting_break`, and when it fires we set the break's target end time to `(moment Away began) + break_minutes`, not `(moment Away is detected) + break_minutes`. This means detection lag (up to 5 minutes) doesn't cost you break time you already took.

Considered alternatives: (1) start the break fresh from the moment Away is detected — simpler, but shortchanges you by up to 5 minutes every time; (2) only use Away to silently dismiss the nagging popup without starting a timer — leaves the "did I already take my break" ambiguity unresolved. Rejected both because they don't actually solve the "I already went from the computer" problem, just work around its symptom.

We didn't extend this to `awaiting_return` (the "I'm back" popup): going Away there means you're still away, not back, so idle detection would say the opposite of what's needed.
