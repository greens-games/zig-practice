const std = @import("std");

fn addOne(x: u8) u8 {
    return x + 1;
}

fn addTwo(x: u8) u8 {
    return x + 2;
}

fn addOneByReference(x: *u8) void {
    x.* += 1;
}

fn addTwoByReference(x: *u8) void {
    x.* += 2;
}

test "test_fn_ptrs" {

    //Stuff on function pointers
    //These are the 2 ways to declare a function pointer
    //You can make a *const reference to a function, this allows you to change the function that the pointer points to this looks like: *const fn (params) return_type
    //You can also make a comptime reference to the function using fn (params) return_type, this value cannot be changes and must be a const variable
    var fn_ptr: *const fn (u8) u8 = &addOne; //this works and allows changing the function that the pointer points to
    //var fn_ptr2: fn (u8) u8 = &addOne; // this doesn't work and will throw an error
    const fn_ptr3: fn (u8) u8 = addOne; // this works and doesn't allow changing the function that the pointer points to
    var x: u8 = 5;
    fn_ptr = addTwo;
    x = fn_ptr(x);
    try std.testing.expect(x == 7);
    x = fn_ptr3(x);
    try std.testing.expect(x == 8);

    var fn_ptr_ref: *const fn (*u8) void = &addOneByReference;
    const fn_ptr2_ref: fn (*u8) void = addOneByReference;
    var x_ref: u8 = 5;
    fn_ptr_ref = addTwoByReference;
    fn_ptr_ref(&x_ref);
    try std.testing.expect(x_ref == 7);
    fn_ptr2_ref(&x_ref);
    try std.testing.expect(x_ref == 8);
}
