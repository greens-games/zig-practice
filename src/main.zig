const std = @import("std");
const my_server = @import("entry.zig");
const user_input = @import("user_input/input.zig");
const learning = @import("learning/interfaces.zig");
const posix = std.posix;
const net = std.net;
const os = std.os;

//NOTE:
//recvFrom is for UDP connection (UDP doesn't care about who sent the request it is connectionless) (Typically stuff like VoIP)
//recv is for TCP requests (TCP requires a connection) (Typically HTTP etc..)
const thing = struct {
    x: i32,
};

pub fn main() !void {

    //Stuff on function pointers

    std.debug.print("Starting server \n", .{});
    learning.try_stuff();
    //try my_server.start_posix_server();
}
