require 'rlepton/version'
require 'shellwords'
require 'open3'
require 'logger'

module RLepton
  # File to be compressed
  class Image
    attr_reader :binary_path
    def initialize(binary_path)
      @binary_path = binary_path

      yield self if block_given?
    end

    def compress(input_file: nil, output_file: nil, input: nil, parameters: [])
      puts input_file
      if self.class.input_file_valid?(input_file)
        return compress_by_files(input_file,
                                 output_file,
                                 parameters)
      end
      return comrpess_by_pipes(input, parameters) if input.is_a?(String) && input.jpeg?
      raise 'Invalid arguments provided'
    end

    def decompress(input_file: nil, output_file: nil, input: nil, parameters: [])
      if self.class.compress_input_file_valid?(input_file)
        return decompress_by_files(input_file, output_file, parameters)
      end
      return decompress_by_pipes(input, parameters) if input.is_a?(String) && input.lep?
      raise 'Invalid arguments provided'
    end

    private

    def log(message, level = ::Logger::INFO)
      return unless self.class.logger

      case level
      when ::Logger::INFO
        self.class.logger.info(message)
      when ::Logger::ERROR
        self.class.logger.error(message)
      when ::Logger::WARN
        self.class.logger.warn(message)
      end
    end

    def decompress_by_files(input_file, output_file, parameters)
      parameters << input_file
      parameters << output_file if output_file

      stdout, stderr, st = execute_by_file(parameters)
      if st
        log(stderr)
        return stdout
      else
        log(stderr, Logger::ERROR)

        raise 'Decompression Exception'
      end
    end

    def compress_by_files(input_file, output_file, parameters)
      parameters << input_file
      parameters << output_file if output_file

      stdout, stderr, st = execute_by_file(parameters)
      if st
        log(stderr)
        return stdout
      else
        log(stderr, Logger::ERROR)

        raise 'Compression Exception'
      end
    end

    def decompress_by_pipes(input, parameters)
      stdout, sterr, st = execute_by_pipe input, parameters
      if st
        log.info stderr
        return stdout
      else
        log(stderr, Logger::ERROR)

        raise 'Decompression Exception'
      end
    end


    def compress_by_pipes(input, parameters)
      stdout, stderr, st = execute_by_pipe input, parameters
      if st
        log.info stderr
        return stdout
      else
        log.error stderr
        raise 'Compression Exception'
      end
    end

    def execute_by_file(parameters)
      ::Open3.capture3(binary_path, *parameters)
    end

    def execute_by_pipe(input, parameters)
      parameters << '-'
      ::Open3.capture3(binary_path, *parameters, stdin_data: input)
    end

    class << self
      attr_accessor :logger
      def input_file_valid?(file)
        return false unless File.exist?(file)
        return false unless ::File.open(file, &:jpeg?)
        true
      end

      def compress_input_file_valid?(file)
        return false unless File.exist?(file)
      end

      def jpeg_string?(str)
        str.jpeg?
      end
    end
  end

  # Helper function for File and String validataion
  module JPEGHelper
    def jpeg?
      require 'mimemagic'
      ::MimeMagic.by_magic(self).type =~ %r{image/jpeg}
    end
  end
end

# Open class to add jpeg? function
class File
 include ::RLepton::JPEGHelper
end

# Open class to add jpeg? function
class String
  include ::RLepton::JPEGHelper
end
