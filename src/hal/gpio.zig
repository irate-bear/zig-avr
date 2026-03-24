pub const Mode = enum {
    input,
    output,
    input_pullup,
};

pub const PinState = enum(u1) {
    high = 0,
    low = 1,

    pub fn fromBool(b: bool) PinState {
        return if (b) .high else .low;
    }

    pub fn toBool(self: PinState) bool {
        return self == .high;
    }
};

pub const Pin = struct {
    port: *volatile u8,
    ddr: *volatile u8,
    pin_reg: *volatile u8,
    bit: u3,
};

pub const Port = enum(u8) {
    A = 0,
    B = 1,
    C = 2,
    D = 3,
    E = 4,
    F = 5,
    G = 6,
    H = 7,
    J = 8,
    K = 9,
    L = 10,
};

pub const PortRegisters = struct {
    pin: *volatile u8,
    ddr: *volatile u8,
    port: *volatile u8,
};

pub fn pinMode(pin: Pin, mode: Mode) void {
    switch (mode) {
        .output => pin.ddr.* |= (@as(u8, 1) << pin.bit),
        .input => pin.ddr.* &= ~(@as(u8, 1) << pin.bit),
        .input_pullup => {
            pin.ddr.* &= ~(@as(u8, 1) << pin.bit);
            pin.port.* |= (@as(u8, 1) << pin.bit);
        },
    }
}

pub fn digitalWrite(pin: Pin, pinstate: PinState) void {
    switch (pinstate) {
        .high => pin.port.* |= (@as(u8, 1) << pin.bit),
        .low => pin.port.* &= ~(@as(u8, 1) << pin.bit),
    }
}

pub fn digitalRead(pin: Pin) PinState {
    return if ((pin.pin_reg.* & (@as(u8, 1) << pin.bit)) != 0)
        .high
    else
        .low;
}

pub fn makePin(port: PortRegisters, bit: u3) Pin {
    return Pin{
        .ddr = port.ddr,
        .pin_reg = port.pin,
        .port = port.port,
        .bit = bit,
    };
}
