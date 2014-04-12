module Chip8Rb
  class Disassembler
    def disassemble(memory)
      pc = 0

      while pc < memory.size

      	if memory[pc] == 0
      		pc += 2
      		next
      	end

        first_ninble = (memory[pc] >> 4)

      	case first_ninble
        when 0x0
          case memory[pc + 1]
      	  when 0xE0
            puts "CLS"
      	  when 0xEE
      		    puts "RET"
          end
      	when 0x1
      		puts sprintf("%-10s $%01x%02x", "JP", memory[pc]&0xf, memory[pc + 1])
      	when 0x2
          puts sprintf("%-10s $%01x%02x", "CALL", memory[pc]&0xf, memory[pc + 1])
      	when 0x3
      		puts sprintf("%-10s v%01x, %02x", "SE", memory[pc]&0xf, memory[pc + 1])
      	when 0x4
          puts sprintf("%-10s v%01x, %02x", "SNE", memory[pc]&0xf, memory[pc + 1])
      	when 0x5
          puts sprintf("%-10s v%01x, V%01x", "SE", memory[pc]&0xf, (memory[pc + 1] >> 4)&0xf)
      	when 0x6
      		puts sprintf("%-10s v%01x, %02x", "LD", memory[pc]&0xf, memory[pc + 1])
      	when 0x7
          puts sprintf("%-10s v%01x, %02x", "ADD", memory[pc]&0xf, memory[pc + 1])
      	when 0x8
          case memory[pc + 1] & 0xf
          when 0x1
            puts sprintf("%-10s v%01x, v%01x", "OR", memory[pc]&0xf, (memory[pc + 1] >> 4)&0xf)
          when 0x2
            puts sprintf("%-10s v%01x, v%01x", "AND", memory[pc]&0xf, (memory[pc + 1] >> 4)&0xf)
          when 0x3
            puts sprintf("%-10s v%01x, v%01x", "XOR", memory[pc]&0xf, (memory[pc + 1] >> 4)&0xf)
          when 0x4
            puts sprintf("%-10s v%01x, v%01x", "ADD", memory[pc]&0xf, (memory[pc + 1] >> 4)&0xf)
          when 0x5
            puts sprintf("%-10s v%01x, v%01x", "SUB", memory[pc]&0xf, (memory[pc + 1] >> 4)&0xf)
          when 0x6
            puts sprintf("%-10s v%01x, v%01x", "SHR", memory[pc]&0xf, (memory[pc + 1] >> 4)&0xf)
          when 0x7
            puts sprintf("%-10s v%01x, v%01x", "SUBN", memory[pc]&0xf, (memory[pc + 1] >> 4)&0xf)
          when 0xE
            puts sprintf("%-10s v%01x, v%01x", "SHL", memory[pc]&0xf, (memory[pc + 1] >> 4)&0xf)
          end
      	when 0x9
          puts sprintf("%-10s v%01x, v%01x", "SNE", memory[pc]&0xf, memory[pc + 1]&0xf)
      	when 0xA
          puts sprintf("%-10s $%01x%02x", "LD", memory[pc]&0xf, memory[pc + 1])
      	when 0xB
          puts sprintf("%-10s $%01x%02x", "JP", memory[pc]&0xf, memory[pc + 1])
      	when 0xC
      		puts sprintf("%-10s V%01x, %02x", "RND", memory[pc]&0xf, memory[pc + 1])
      	when 0xD
          puts sprintf("%-10s V%01x, %02x", "DRW", memory[pc]&0xf, memory[pc + 1])
      	when 0xE
      		print_instruction("SKP", memory[pc], memory[pc + 1])

          case memory[pc + 1]
          when 0x9E
            puts sprintf("%-10s V%01x", "SKP", memory[pc]&0xf)
          when 0xA1
            puts sprintf("%-10s V%01x", "SKNP", memory[pc]&0xf)
          end

      	when 0xF

          case memory[pc + 1]
          when 0x07
            puts sprintf("%-10s V%01x, %02x", "LD", memory[pc]&0xf, memory[pc + 1])
          when 0x0A
            puts sprintf("%-10s V%01x, %02x", "LD", memory[pc]&0xf, memory[pc + 1])
          when 0x15
            puts sprintf("%-10s V%01x, %02x", "LD", memory[pc]&0xf, memory[pc + 1])
          when 0x18
            puts sprintf("%-10s V%01x, %02x", "LD", memory[pc]&0xf, memory[pc + 1])
          when 0x1E
            puts sprintf("%-10s V%01x", "ADD", memory[pc]&0xf)
          when 0x29
            puts sprintf("%-10s V%01x, %02x", "LD", memory[pc]&0xf, memory[pc + 1])
          when 0x33
            puts sprintf("%-10s V%01x, %02x", "LD", memory[pc]&0xf, memory[pc + 1])
          when 0x55
            puts sprintf("%-10s V%01x, %02x", "LD", memory[pc]&0xf, memory[pc + 1])
          when 0x65
            puts sprintf("%-10s V%01x, %02x", "LD", memory[pc]&0xf, memory[pc + 1])
          end
      	end

      	pc += 2
      end
    end

    def print_instruction(a,b,c)
    end
  end
end

filename = "/Users/josedonizetti/workspace/chip8_rb/games/INVADERS"
memory = File.open(filename, "rb") {|f| f.read }.unpack("C*")

disassembler = Chip8Rb::Disassembler.new
disassembler.disassemble(memory)
