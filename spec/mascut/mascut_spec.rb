require File.join(File.dirname(__FILE__), %w[ .. spec_helper ])

describe Mascut::Mascut, '#new' do
  context 'called with only an app' do
    let(:app) { nil }
    subject { Mascut::Mascut.new(app) }
    
    before do
      # Dir.chdir(tmpdir)
      # tmpdir has some files
    end

    after do
      # Dir.chdir(currentdir)
      # delete tmpdir
    end

    it 'should assign @path with default value /mascut' do
      subject.instance_variable_get(:@path).should == '/mascut'
    end

    it %(should assign @files with default value Dir['**/*']) do
      pending 'I should change Dir to tmpdir'
    end

    it 'should assign @opts with default value {}' do
      subject.instance_variable_get(:@opts).should == {}
    end
  end
end

describe Mascut::Mascut, '#call' do
  let(:app) { mock }
  let(:files) { [ ] }
  let(:middleware) { Mascut::Mascut.new(app, '/mascut', files, {}) }
  
  subject { middleware.call('PATH_INFO' => path)  }

  let(:html) { '<html><head></head><body></body>' }

  context 'if path is not mascut' do
    let(:path) { '/hoge.html' }
    let(:html) { '<html><head></head><body></body>' }

    it 'app should be called' do
      mock(app).call('PATH_INFO' => path)
      subject
    end

    context 'if app returns html with status 200' do
      before do
        stub(app).call { [ 200, { 'Content-Type' => 'text/html' }, [ html ] ] }
      end

      it 'should call mascutize' do
        mock(middleware).mascutize(html) { 'mascutized' }
        subject
      end

      it 'should also returns 200' do
        subject[0].should == 200
      end

      it 'should add updated content length' do
        stub(middleware).mascutize { '12characters' }
        subject[1].should include('Content-Length' => 12.to_s )
      end

      it 'should return mascutized values' do
        mock(middleware).mascutize(html) { 'mascutized' }
        subject[2].should == [ 'mascutized' ]
      end
    end

    context 'if app returns a kind of Rack::Response' do
      it 'should have specs'
    end
    
    [ [ 201, { 'Content-Type' => 'text/html' }, [ 'html' ] ],
      [ 200, { 'Content-Type' => 'text/css'  }, [ 'css'  ] ],
    ].each do |response|
      context "when status is #{response[0]} and Content-Type is #{response[1]['Content-Type']}" do
        before do
          stub(app).call { response }
        end
        
        it 'should return as is' do
          subject.should == response
        end
      end
    end
  end

  context 'if path is mascut' do
    let(:path) { '/mascut' }
    it 'should wait until the files are updated' do
      pending 'thread and benchmark'
    end
  end
end

describe Mascut::Mascut, '#mascut' do
  it 'should have specs'
end

describe Mascut::Mascut, '#mascutize' do
  let(:app) { mock }
  let(:html) { '<html><head></head><body></body>' }
  subject { Mascut::Mascut.new(app, nil, nil, opts).mascutize(html) }
    
  context 'if use local jquery' do
    let(:jquery) { 'jquery_file' }
    let(:opts) { { :jquery => jquery } }

    it "should include local jquery path" do
      subject.should =~ /#{jquery}/
    end
  end

  context 'if use remote jquery' do
    let(:opts) { {} }
    
    it 'should load jquery from google' do
      subject.should =~ /http:\/\/www\.google\.com\/jsapi/
    end
  end
end

