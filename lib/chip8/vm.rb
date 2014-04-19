module Chip8
  class VM
    attr_reader :memory, :sp, :pc, :registers

    def initialize(program)
      @program = program
      initialize_memory
      load_program

      @sp = 0
      @pc = 0x200

      @registers = {}
      # 0 to F
      16.times { |i| @registers["v#{i}".to_sym] = 0 }
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
        end

        @pc += 2
      end
    end

    class << self
      def load(program)
        VM.new(program)
      end
    end

    private

    def op0x1(byte1, byte2)
      @pc = "#{(byte1 & 0xf).to_s(16)}#{byte2.to_s(16)}".hex
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
    end

    def get_register_x(byte)
      "v#{(byte & 0xF)}".to_sym
    end

    def get_register_y(byte)
      "v#{(byte >> 4)}".to_sym
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
