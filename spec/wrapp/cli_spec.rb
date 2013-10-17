require 'spec_helper'

module Wrapp
  describe CLI do
    let(:cli) { CLI.new }
    let(:app_path) { '/Applications/Chunky Bacon.app' }

    describe '.run' do
      it 'runs an instance with ARGV' do
        cli.should_receive(:run).with(ARGV)
        CLI.stub(:new).and_return(cli)
        CLI.run
      end
    end

    describe '#run' do
      let(:argv) { [app_path] }

      it 'wraps the app' do
        cli.should_receive(:wrapp).with(app_path, {})
        cli.run(argv)
      end

      %w(--include-parent-dir -i).each do |opt|
        context "with #{opt}" do
          let(:argv) { [app_path, opt] }

          it 'wraps the app including the parent directory' do
            cli.should_receive(:wrapp).
              with(app_path, :include_parent_dir => true)
            cli.run(argv)
          end
        end
      end
    end

    describe '#wrapp' do
      it 'creates the dmg via dmg builder' do
        opts = %(some options and arguments)
        dmg = double('dmg_builder')
        dmg.should_receive(:create)
        DMGBuilder.should_receive(:new).with(*opts).and_return(dmg)
        cli.wrapp(*opts)
      end
    end
  end
end
