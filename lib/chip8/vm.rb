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
      i = (byte1 & 0xF)
      @pc += 2 if registers["v#{i}".to_sym] == byte2
    end

    def op0x4(byte1, byte2)
      i = (byte1 & 0xF)
      @pc += 2 if registers["v#{i}".to_sym] != byte2
    end

    def op0x5(byte1, byte2)
      x = (byte1 & 0xF)
      y = (byte2 >> 4)
      @pc += 2 if registers["v#{x}".to_sym] == registers["v#{y}".to_sym]
    end

    def op0x6(byte1, byte2)
      register = "v#{(byte1 & 0xf)}".to_sym
      @registers[register] = byte2
    end

    def op0x7(byte1, byte2)
      register = "v#{(byte1 & 0xf)}".to_sym
      @registers[register] = byte2
    end

    def op0x8(byte1, byte2)
      case (byte2 & 0xF)
      when 0x0; op0x8_0(byte1, byte2)
      when 0x1; op0x8_1(byte1, byte2)
      when 0x2; op0x8_2(byte1, byte2)
      end

    end

    def op0x8_0(byte1, byte2)
      register1 = "v#{(byte1 & 0xf)}".to_sym
      register2 = "v#{(byte2 >> 4) & 0xf}".to_sym
      @registers[register1] = @registers[register2]
    end

    def op0x8_1(byte1, byte2)
      register1 = "v#{(byte1 & 0XF)}".to_sym
      register2 = "v#{(byte2 >> 4)}".to_sym
      @registers[register1] = @registers[register1] | @registers[register2]
    end

    def op0x8_2(byte1, byte2)
      register1 = "v#{(byte1 & 0xF)}".to_sym
      register2 = "v#{(byte2 >> 4)}".to_sym
      @registers[register1] = @registers[register1] & @registers[register2]
    end

  end
end