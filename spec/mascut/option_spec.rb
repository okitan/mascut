require File.join(File.dirname(__FILE__), %w[ .. spec_helper ])

describe Mascut::Option, '#parse' do
  let(:value) { 'value' }
  
  context 'String option' do
    [ %w[ -s --server server ],
      %w[ -o --host   Host ],
    ].each do |short, long, key|
      context "with short option #{short}" do
        subject { Mascut::Option.parse([ short, value ]) }
        
        it "should assign #{key}" do
          subject[key.to_sym].should == value
        end
      end
      
      context "with long option #{long}" do
        it 'should have specs'
      end
    end

    context '-m --mascut' do
      context 'with short option -m' do
        it 'should assign mascut and add its head /' do
          Mascut::Option.parse(%w[ -m mascut ])[:mascut].should == '/mascut'
        end
        
        it 'should assign mascut and add its head /' do
          Mascut::Option.parse(%w[ -m /mascut ])[:mascut].should == '/mascut'
        end
      end
      
      context 'with long option --mascut' do
        it 'should have specs'
      end
    end
  end

  context 'Integer option' do
    [ %w[ -p --port Port ],
    ].each do |short, long, key|
      # XXX: now default value is Integer but parsed value is String
      it 'should have specs'
    end
  end

  context 'Float option' do
    [ %w[ -i --interval interval],
    ].each do |short, long, key|
      it 'should have specs'
    end
  end
  
  # returns true/false
  context 'boolean option' do
    [
      %w[ -D --daemonize daemonize],
    ].each do |short, long, key|
      it 'should have specs'
    end
  end

  [ [ :server, 'mongrel' ],
    [ :Host,   '0.0.0.0' ],
    [ :Port,    9203 ],
  ].each do |key, default_value|
    context "when #{key} is not specified" do
      subject { Mascut::Option.parse([]) }
      
      it 'should be assigned default value' do
        subject[key].should == default_value
      end
    end
  end
end

