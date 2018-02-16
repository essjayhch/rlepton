require 'rlepton/version'
require 'shellwords'

module RLepton
  class Image
     def initialize(binary_path)
       @@binary_path = binary_path
     end

     def compress(input_file:, output_file:nil, parameters: {})
       raise 'Input file not JPEG' unless ::Rlepton::Image.jpeg? input_file
       raise 'Output file not Lepton' unless ::Rlepton::Image.lep? output_file

       parameters = parameters.join(' ')
       f_input = Shellwords.escape(input_file)
       f_output = Shellwords.escape(output_file)
       return_value = system "#{RLepton::Image.binary_path} #{parameters} #{f_input} #{f_output}"

       raise 'Compression Exception' unless return_value == 0

       self
     end

     def decompress(input_file:, output_file:nil)
       raise 'Output file not JPEG' unless ::Rlepton::Image.jpeg? output_file
       raise 'Input file not Lepton' unless ::Rlepton::Image.lep? input_file

       parameters = parameters.join(' ')
       f_input = Shellwords.escape(input_file)
       f_output = Shellwords.escape(output_file)

       return_value = system "#{RLepton::Image.binary_path} #{parameters} #{f_input} #{f_output}"

       raise 'Compression Exception' unless return_value == 0

       self
     end

     class << self
       attr_reader :binary_path

       def compressable?(input_file)
         ::Rlepton::Image.jpeg? input_file
       end

       protected

       def lepton?(file_name)
         ::File.extname(file_name).eql? 'lep'
       end

       def jpeg?(file_name)
         mime(file_name) =~ %r(image/jpeg)
       end

       def mime(file_name)
         require 'filemagic'

         ::FileMagic.open(:mime) do |fm|
           fm.file(file_name)
         end
       end
     end
  end
  class InvalidFileType < StandardError
  end
end
