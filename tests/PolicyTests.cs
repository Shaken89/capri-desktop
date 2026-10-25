using System;
using CapriDesktop;
class PolicyTests
{
    static void Main()
    {
        if (AnimationPolicy.Complete(AnimationState.Grin, 31, 16) || !AnimationPolicy.Complete(AnimationState.Grin, 32, 16)) throw new Exception("Grin duration");
        if (AnimationPolicy.Complete(AnimationState.Sleep, 100, 16)) throw new Exception("Sleep must loop");
        if (!AnimationPolicy.Seated(AnimationState.PerchGlitch)) throw new Exception("Perch transition");
        double once = AnimationPolicy.Approach(0, 3, .1), twice = AnimationPolicy.Approach(AnimationPolicy.Approach(0, 3, .05), 3, .05);
        if (Math.Abs(once - twice) > 1e-9 || once <= 0 || once >= 3) throw new Exception("Frame independent smoothing");
        Console.WriteLine("PASS animation policies and smoothing");
    }
}
