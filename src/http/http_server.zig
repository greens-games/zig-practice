const std = @import("std");
const http = @import("./my_http.zig");

pub fn process_request(req: http.Request) !void {
    _ = req;
}
