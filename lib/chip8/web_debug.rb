require 'sinatra/base'
require 'chip8'

module Chip8
  class WebDebug < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/web_debug/views"
    set :public_folder, "#{dir}/web_debug/public"
    set :static, true
    set :method_override, true

    get '/' do
      base = "/Users/josedonizetti/workspace"
      @@program ||= File.read("#{base}/chip8_rb/games/INVADERS") {|file| file.read }.unpack("C*")
      @@vm ||= VM.new(@@program)


      @memory = @@vm.memory[0x200, @@vm.memory.size]
      @registers = @@vm.registers
      @keyboard = @@vm.keyboard
      @stack = @@vm.stack
      @current_index = (@@vm.pc - 0x200)

      @special_registers = {}

      @special_registers[:program_counter] = "0x#{@@vm.pc.to_s(16)}"
      @special_registers[:stack_pointer] = @@vm.st
      @special_registers[:I] = @@vm.i
      @special_registers[:delay_timer] = @@vm.dt
      @special_registers[:sound_timer] = @@vm.st

      erb :index
    end
  end
end
