const std = @import("std");

//Let's make 3 structs
//One has member functions
//THe other has funciton pointers
//The last has function pointers and member functions
//

const Interface = struct {
    impl: *const fn () void = undefined,
};

const Impl1 = struct {
    x: u32 = 1,
    interface: Interface = .{
        .impl = &Impl1.do_stuff,
    },
    fn do_stuff() void {
        std.debug.print("Impl1::do_stuff\n", .{});
    }
};

const Impl2 = struct {
    x: u32 = 0,
    interface: Interface = .{
        .impl = &Impl2.do_stuff,
    },
    fn do_stuff() void {
        std.debug.print("Impl2::do_stuff\n", .{});
    }
};

pub fn try_stuff() void {
    const impl1 = Impl1{};
    var inferface: Interface = impl1.interface;
    inferface.impl();
    const impl2 = Impl2{};
    inferface = impl2.interface;
    inferface.impl();
}
