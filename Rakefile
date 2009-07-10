require 'rubygems'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
        s.name = 'xmpp4log'
        s.version = '0.0.2'
        s.platform = Gem::Platform::RUBY
        s.summary = "A Logger via xmpp"

        s.author = "Di Cioccio Lucas"
        s.email = "lucas.dicioccio<@nospam@>frihd.net"
        s.rubyforge_project = 'xmpp4log'
        s.homepage = 'http://rubyforge.org/projects/xmpp4log'

        s.files = ['README', 'LICENSE', 'gpl-3.0.txt', 'Rakefile', 'TODO', 'lib/xmpp4log.rb']

	s.add_dependency('xmpp4r-simple', '>= 0.8.8')
        s.require_path = 'lib'

        s.has_rdoc = false
end

Rake::GemPackageTask.new(spec) do |pkg|
        pkg.need_tar = true
end

task :gem => "pkg/#{spec.name}-#{spec.version}.gem" do
        puts "generated #{spec.version}"
end

