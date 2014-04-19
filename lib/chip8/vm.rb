module Chip8
  class VM
    attr_reader :memory, :sp, :pc, :registers, :i

    def initialize(program)
      @program = program
      initialize_memory
      load_program

      @sp = 0
      @pc = 0x200

      @registers = {}
      # 0 to F
      16.times { |i| @registers["v#{i}".to_sym] = 0 }

      @i = 0
    end

    def initialize_memory
      @memory = []
      4096.times { |i| @memory[i] = 0 }
    end

    def load_program
      index = 0
      while index < @program.size
        memory[0x200 + index] = @program[index]
        index += 1
      end
    end

    def execute
      index = 0
      while (@memory[pc] != 0x00) && (@pc < @memory.size)
        byte1 = memory[@pc]
        byte2 = memory[@pc + 1]

        case (byte1 >> 4)
        when 0x1; op0x1(byte1, byte2); next
        when 0x3; op0x3(byte1, byte2)
        when 0x4; op0x4(byte1, byte2)
        when 0x5; op0x5(byte1, byte2)
        when 0x6; op0x6(byte1, byte2)
        when 0x7; op0x7(byte1, byte2)
        when 0x8; op0x8(byte1, byte2)
        when 0x9; op0x9(byte1, byte2)
        when 0xA; op0xA(byte1, byte2)
        when 0xB; op0xB(byte1, byte2); next
        when 0xF; op0xF(byte1, byte2)
        end

        @pc += 2
      end
    end

    private

    def op0x1(byte1, byte2)
      nnn = get_nnn(byte1, byte2)
      @pc = nnn
    end

    def op0x3(byte1, byte2)
      x = get_register_x(byte1)
      skip_next_instruction if equal_register_to_byte?(x, byte2)
    end

    def op0x4(byte1, byte2)
      x = get_register_x(byte1)
      skip_next_instruction if !equal_register_to_byte?(x, byte2)
    end

    def op0x5(byte1, byte2)
      x = get_register_x(byte1)
      y = get_register_y(byte2)
      skip_next_instruction if equal_register_to_register?(x, y)
    end

    def op0x6(byte1, byte2)
      x = get_register_x(byte1)
      @registers[x] = byte2
    end

    def op0x7(byte1, byte2)
      x = get_register_x(byte1)
      @registers[x] = @registers[x] + byte2
    end

    def op0x8(byte1, byte2)
      case (byte2 & 0xF)
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
      x = get_register_x(byte1)
      y = get_register_y(byte2)
      @registers[x] = @registers[y]
    end

    def op0x8_1(byte1, byte2)
      x = get_register_x(byte1)
      y = get_register_y(byte2)
      @registers[x] = @registers[x] | @registers[y]
    end

    def op0x8_2(byte1, byte2)
      x = get_register_x(byte1)
      y = get_register_y(byte2)
      @registers[x] = @registers[x] & @registers[y]
    end

    def op0x8_3(byte1, byte2)
      x = get_register_x(byte1)
      y = get_register_y(byte2)
      @registers[x] = @registers[x] ^ @registers[y]
    end

    def op0x8_4(byte1, byte2)
      x = get_register_x(byte1)
      y = get_register_y(byte2)
      @registers[x] = @registers[x] + @registers[y]
      @registers[:v15] = @registers[x] > 255 ? 1 : 0

      #TODO: write spec to this case
      @registers[x] -= 256 if @registers[x] > 255
    end

    def op0x8_5(byte1, byte2)
      x = get_register_x(byte1)
      y = get_register_y(byte2)
      @registers[:v15] = @registers[x] > @registers[y] ? 1 : 0
      @registers[x] = @registers[x] - @registers[y]

      #TODO: write spec to this case
      @registers[x] += 256 if @registers[x] < 0
    end

    def op0x8_6(byte1, byte2)
      x = get_register_x(byte1)
      @registers[:v15] = @registers[x] & 0x1
      @registers[x] = @registers[x] >> 1
    end

    def op0x8_7(byte1, byte2)
      x = get_register_x(byte1)
      y = get_register_y(byte2)
      @registers[:v15] = @registers[y] > @registers[x] ? 1 : 0
      @registers[x] = @registers[y] - @registers[x]

      #TODO: write spec to this case
      @registers[x] += 256 if @registers[x] < 0
    end

    def op0x8_E(byte1, byte2)
      x = get_register_x(byte1)
      @registers[:v15] = (@registers[x] & 0x80 > 0) ? 1 : 0
      @registers[x] = @registers[x] << 1

      #TODO: write spec to this case
      @registers[x] -= 256 if @registers[x] > 255
    end

    def op0x9(byte1, byte2)
      x = get_register_x(byte1)
      y = get_register_y(byte2)
      skip_next_instruction if !equal_register_to_register?(x,y)
    end

    def op0xA(byte1, byte2)
      nnn = get_nnn(byte1, byte2)
      @i = nnn
    end

    def op0xB(byte1, byte2)
      nnn = get_nnn(byte1, byte2)
      @pc = nnn + @registers[:v0]
    end

    def op0xF(byte1, byte2)
      case byte2
      when 0x33; op0xF_33(byte1)
      when 0x55; op0xF_55(byte1)
      when 0x65; op0xF_65(byte1)
      end
    end

    def op0xF_33(byte1)
      x = get_register_x(byte1)
      value = @registers[x]
      index = 2
      while index >= 0
        @memory[@i + index] = value % 10
        value = value / 10
        index -= 1
      end
    end

    def op0xF_55(byte1)
      x = get_register_x(byte1)
      0.upto(@registers[x]) do |n|
        @memory[@i] = @registers["v#{n}".to_sym]
        @i += 1
      end
    end

    def op0xF_65(byte1)
      x = get_register_x(byte1)
      0.upto(@registers[x]) do |n|
        register = "v#{n}".to_sym
        @registers[register] = @memory[@i + n]
      end
    end

    def get_register_x(byte)
      "v#{(byte & 0xF)}".to_sym
    end

    def get_register_y(byte)
      "v#{(byte >> 4)}".to_sym
    end

    def get_nnn(byte1, byte2)
      if byte2 == 0
        "#{(byte1 & 0xf).to_s(16)}00".hex
      elsif byte2 < 0x10
        "#{(byte1 & 0xf).to_s(16)}0#{byte2.to_s(16)}".hex
      else
        "#{(byte1 & 0xf).to_s(16)}#{byte2.to_s(16)}".hex
      end
    end

    def equal_register_to_byte?(register, byte)
      @registers[register] == byte
    end

    def equal_register_to_register?(register1, register2)
      registers[register1] == registers[register2]
    end

    def skip_next_instruction
      @pc += 2
    end

  end
end
