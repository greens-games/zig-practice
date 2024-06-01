const std = @import("std");
const my_server = @import("server.zig");
const user_input = @import("user_input/input.zig");
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
    //try user_input.user_input_with_prompt();
    //try user_input.read_in_file();
    //try user_input.get_user_input();
    //try my_server.start_server();
    std.debug.print("Starting server\n", .{});

    try my_server.start_posix_server();
}
