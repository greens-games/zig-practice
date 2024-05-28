const std = @import("std");
const net = std.net;
const posix = std.posix;

//NOTE:
//Both the start_server and start_posix_server fail with socket nto connected when reading
//doesn't matter if we use posix or net we get the same issue

pub fn start_server() !void {
    std.debug.print("starting server\n", .{});

    const s = try posix.socket(std.posix.AF.INET, posix.SOCK.STREAM, 0); //Create the IPv4 socket as a stream socket (Used for TCP) (UDP would use DGRAM)
    const a = try net.Address.resolveIp("127.0.0.1", 7001); //get the IPv4 address for localhost:7001
    const stream: net.Stream = .{ .handle = s };
    var server: net.Server = .{ .listen_address = a, .stream = stream };
    server = try server.listen_address.listen(.{});

    while (true) {
        const conn: net.Server.Connection = try server.accept();
        _ = conn;
        var buf: [1024]u8 = undefined;
        const num_read: usize = try stream.read(&buf);
        std.debug.print("waiting for message\n", .{});
        std.debug.print("received: {s}\n", .{buf[0..]});
        _ = num_read;
        std.time.sleep(5000000000);
    }
}

pub fn start_posix_server() !void {
    var a = try net.Address.resolveIp("127.0.0.1", 7001); //get the IPv4 address for localhost:7001
    var sock_len = net.Address.getOsSockLen(a); //get the length of the socket defined by the OS

    const s = try start_TCP(); //Create the IPv4 socket as a stream socket (Used for TCP) (UDP would use DGRAM)
    defer posix.close(s);

    try posix.bind(s, &a.any, sock_len); //bind the socket to the address localhost:7001

    try mandatory_TCP(s);
    //std.debug.print("accept returned {}\n", .{n});
    const n = try posix.accept(s, &a.any, &sock_len, 0); //tell the socket at given address to start accepting connections
    _ = n;
    std.debug.print("accepting\n", .{});
    while (true) {
        var buf: [1024]u8 = [_]u8{0} ** 1024;
        const num_read: usize = try posix.recv(s, &buf, 0); // receive a message from the socket
        std.debug.print("waiting for message\n", .{});
        std.debug.print("received: {s}\n", .{buf[0..]});
        _ = num_read;
        std.time.sleep(5000000000);
    }

    sock_len = undefined;
    std.debug.print("Made it to the end\n socket: {} addr: {}\n", .{ s, a });
}

fn start_UDP() posix.SocketError!posix.socket_t {
    const s = posix.socket(std.posix.AF.INET, posix.SOCK.DGRAM, 0); //Create the IPv4 socket as a stream socket (Used for TCP) (UDP would use DGRAM)
    return s;
}

fn start_TCP() posix.SocketError!posix.socket_t {
    const s = try posix.socket(std.posix.AF.INET, posix.SOCK.STREAM, 0); //Create the IPv4 socket as a stream socket (Used for TCP) (UDP would use DGRAM)
    return s;
}

fn mandatory_TCP(s: posix.socket_t) !void {
    try posix.listen(s, 1024); //tell the socket to start listening
}
