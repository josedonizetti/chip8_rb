class Opcode

  def initialize(byte1, byte2)
    @byte1 = byte1
    @byte2 = byte2
  end

  def parse
    detail = case (@byte1 >> 4)
    when 0x0; op0x0(@byte1, @byte2)
    when 0x1; op0x1(@byte1, @byte2)
    when 0x2; op0x2(@byte1, @byte2)
    when 0x3; op0x3(@byte1, @byte2)
    when 0x4; op0x4(@byte1, @byte2)
    when 0x5; op0x5(@byte1, @byte2)
    when 0x6; op0x6(@byte1, @byte2)
    when 0x7; op0x7(@byte1, @byte2)
    when 0x8; op0x8(@byte1, @byte2)
    when 0x9; op0x9(@byte1, @byte2)
    when 0xA; op0xA(@byte1, @byte2)
    when 0xB; op0xB(@byte1, @byte2)
    when 0xC; op0xC(@byte1, @byte2)
    when 0xD; op0xD(@byte1, @byte2)
    when 0xE; op0xE(@byte1, @byte2)
    when 0xF; op0xF(@byte1, @byte2)
    end

    opcode = get_register_value(@byte1, @byte2)
    "Opcode: #{opcode.upcase} - #{detail}"
  end

  private
  def op0x0(byte1, byte2)
    case byte2
    when 0xE0; op0x0_E0(byte1)
    when 0xEE; op0x0_EE(byte1)
    end
  end

  def op0x0_E0(byte1)
    "CLS"
  end

  def op0x0_E1(byte1)
    "RET"
  end

  def op0x1(byte1, byte2)
    nnn = get_nnn(byte1, byte2)
    "JUMP to location #{nnn}"
  end

  def op0x2(byte1, byte2)
    nnn = get_nnn(byte1, byte2)
    "Call subroutine at #{nnn}."
  end

  def op0x3(byte1, byte2)
    register = get_register_x(byte1)
    "Skip next instruction if #{register} = #{byte2.to_s(16)}."
  end

  def op0x4(byte1, byte2)
    register = get_register_x(byte1)
    "Skip next instruction if #{register} != #{byte2.to_s(16)}."
  end

  def op0x5(byte1, byte2)
    registerX = get_register_x(byte1)
    registerY = get_register_y(byte2)
    "Skip next instruction if #{registerX} = #{registerY}."
  end

  def op0x6(byte1, byte2)
    register = get_register_x(byte1)
    "Set #{register} = #{byte2.to_s(16)}."
  end

  def op0x7(byte1, byte2)
    registerX = get_register_x(byte1)
    "Set #{registerX} = #{registerX} + #{byte2.to_s(16)}."
  end

  def op0x8(byte1, byte2)
    case byte2
    when 0x0; op0x8_0(byte1, byte2)
    when 0x1; op0x8_1(byte1, byte2)
    when 0x2; op0x8_2(byte1, byte2)
    when 0x3; op0x8_3(byte1, byte2)
    when 0x4; op0x8_4(byte1, byte2)
    when 0x5; op0x8_5(byte1, byte2)
    when 0x6; op0x8_6(byte1, byte2)
    when 0x7; op0x8_7(byte1, byte2)
    when 0xE; op0x8_E(byte1, byte2)
    end
  end

  def op0x8_0(byte1, byte2)
    registerX = get_register_x(byte1)
    registerY = get_register_y(byte2)
    "8xy0 - Set #{registerX} = #{registerY}."
  end

  def op0x8_1(byte1, byte2)
    registerX = get_register_x(byte1)
    registerY = get_register_y(byte2)
    "8xy1 - Set #{registerX} = #{registerX} OR #{registerY}."
  end

  def op0x8_2(byte1, byte2)
    registerX = get_register_x(byte1)
    registerY = get_register_y(byte2)
    "8xy2 - Set #{registerX} = #{registerX} AND #{registerY}."
  end

  def op0x8_3(byte1, byte2)
    registerX = get_register_x(byte1)
    registerY = get_register_y(byte2)
    "Set #{registerX} = #{registerX} XOR #{registerY}."
  end

  def op0x8_4(byte1, byte2)
    registerX = get_register_x(byte1)
    registerY = get_register_y(byte2)
    "Set #{registerX} = #{registerX} + #{registerY}, set V15 = carry."
  end

  def op0x8_5(byte1, byte2)
    registerX = get_register_x(byte1)
    registerY = get_register_y(byte2)
    "Set #{registerX} = #{registerX} - #{registerY}, set VF = NOT borrow."
  end

  def op0x8_6(byte1, byte2)
    registerX = get_register_x(byte1)
    registerY = get_register_y(byte2)
    "Set #{registerX} = #{registerX} / 2."
  end

  def op0x8_7(byte1, byte2)
    registerX = get_register_x(byte1)
    registerY = get_register_y(byte2)
    "Set #{registerX} = #{registerY} - #{registerX}, set VF = NOT borrow."
  end

  def op0x8_E(byte1, byte2)
    registerX = get_register_x(byte1)
    "Set #{registerX} = #{registerX} * 2."
  end

  def op0x9(byte1, byte2)
    registerX = get_register_x(byte1)
    registerY = get_register_y(byte2)
    "Skip next instruction if #{registerX} != #{registerY}."
  end

  def op0xA(byte1, byte2)
    nnn = get_nnn(byte1, byte2)
    "Set I = #{nnn}."
  end

  def op0xB(byte1, byte2)
    nnn = get_nnn(byte1, byte2)
    "Jump to location #{nnn} + V0."
  end

  def op0xC(byte1, byte2)
    registerX = get_register_x(byte1)
    "Set #{registerX} = random byte AND #{byte2.to_s(16)}."
  end

  def op0xD(byte1, byte2)
    registerX = get_register_x(byte1)
    registerY = get_register_y(byte2)
    n = byte2&0xF
    "Display #{n}-byte sprite starting at memory location I at (#{registerX}, #{registerY}), set VF = collision."
  end

  def op0xE(byte1, byte2)
    case byte2
    when 0x9E; op0xE_9E(byte1)
    when 0xA1; op0xE_A1(byte1)
    end
  end

  def op0xE_9E(byte1)
    registerX = get_register_x(byte1)
    "Skip next instruction if key with the value of #{registerX} is pressed."
  end

  def op0xE_A1(byte1)
    registerX = get_register_x(byte1)
    "Skip next instruction if key with the value of #{registerX} is not pressed."
  end

  def op0xF(byte1, byte2)
    case byte2
    when 0x07; op0xF_07(byte1)
    when 0x0A; op0xF_0A(byte1)
    when 0x15; op0xF_15(byte1)
    when 0x18; op0xF_18(byte1)
    when 0x1E; op0xF_1E(byte1)
    when 0x29; op0xF_29(byte1)
    when 0x33; op0xF_33(byte1)
    when 0x55; op0xF_55(byte1)
    when 0x65; op0xF_65(byte1)
    end
  end

  def op0xF_07(byte1)
    registerX = get_register_x(byte1)
    "Set #{registerX} = delay timer value."
  end

  def op0xF_0A(byte1)
    registerX = get_register_x(byte1)
    "Wait for a key press, store the value of the key in #{registerX}."
  end

  def op0xF_15(byte1)
    registerX = get_register_x(byte1)
    "Set delay timer = #{registerX}."
  end

  def op0xF_18(byte1)
    registerX = get_register_x(byte1)
    "Set sound timer = #{registerX}."
  end

  def op0xF_1E(byte1)
    registerX = get_register_x(byte1)
    "Set I = I + #{registerX}."
  end

  def op0xF_29(byte1)
    registerX = get_register_x(byte1)
    "Set I = location of sprite for digit #{registerX}."
  end

  def op0xF_33(byte1)
    registerX = get_register_x(byte1)
    "Store BCD representation of #{registerX} in memory locations I, I+1, and I+2."
  end

  def op0xF_55(byte1)
    registerX = get_register_x(byte1)
    "Store registers V0 through #{registerX} in memory starting at location I."
  end

  def op0xF_65(byte1)
    registerX = get_register_x(byte1)
    "Read registers V0 through #{registerX} from memory starting at location I."
  end

  def get_register_x(byte)
    "v#{(byte & 0xF)}".to_sym
  end

  def get_register_y(byte)
    "v#{(byte >> 4)}".to_sym
  end

  def get_nnn(byte1, byte2)
    if byte2 == 0
      "#{(byte1 & 0xf).to_s(16)}00"
    elsif byte2 < 0x10
      "#{(byte1 & 0xf).to_s(16)}0#{byte2.to_s(16)}"
    else
      "#{(byte1 & 0xf).to_s(16)}#{byte2.to_s(16)}"
    end
  end

  def get_register_value(byte1, byte2)

    result1 = nil
    if byte1 == 0
      result1 = "00"
    elsif byte1 < 0x10
      result1 = "0#{(byte1&0xF)}"
    else
      result1 = "#{byte1.to_s(16)}"
    end

    result2 = nil
    if byte2 == 0
      result2 = "00"
    elsif byte2 < 0x10
      result2 = "0#{(byte2&0xF)}"
    else
      result2 = "#{byte2.to_s(16)}"
    end

    "#{result1}#{result2}"
  end
end
