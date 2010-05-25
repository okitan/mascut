require File.join(File.dirname(__FILE__), %w[ .. spec_helper ])

shared_examples_for 'hamlize PATH_INFO' do
  before do
    stub(File).exist?(path) { true }
  end
  
  it 'should hamlize PATH_INFO' do
    mock(middleware).hamlize(path) { 'haml' }
    subject
  end
end

shared_examples_for 'sassize PATH_INFO' do
  before do
    stub(File).exist?(path) { true }
  end
  
  it 'should hamlize PATH_INFO' do
    mock(middleware).sassize(path) { 'sass' }
    subject
  end
end

describe Mascut::Hamlth, '#call' do
  let(:app) { mock }
  let(:middleware) { Mascut::Hamlth.new(app) }
  let(:env) { { 'PATH_INFO' => path } }
  
  subject { middleware.call(env) }
  
  context 'for *.html' do
    let(:path) { 'hoge.html' }

    context 'when *.html exists' do
      it_should_behave_like 'hamlize PATH_INFO'
    end

    context 'when *.haml exists' do
      before do
        stub(File).exist?(path) { false }
        stub(File).exist?('hoge.haml') { true }
      end

      it 'should hamlize *.haml' do
        mock(middleware).hamlize('hoge.haml') { 'haml' }
        subject
      end
    end

    context 'neighter exists' do
      before do
        stub(File).exist?(path) { false }
        stub(File).exist?('hoge.haml') { false }
      end

      it 'should move on to next app' do
        mock(app).call(env)
        subject
      end
    end
  end

  context 'for *.haml' do
    let(:path) { 'hoge.haml' }

    context 'when *.haml exists' do
      it_should_behave_like 'hamlize PATH_INFO'
    end

    context '*.haml does not exist' do
      before do
        stub(File).exist?(path) { false }
      end

      it 'should move on to next app' do
        mock(app).call(env)
        subject
      end
    end
  end

  context 'for *.css' do
    let(:path) { 'hoge.css' }
    
    context 'when *.css exists' do
      it_should_behave_like 'sassize PATH_INFO'
    end

    context 'when *.sass exists' do
      before do
        stub(File).exist?(path) { false }
        stub(File).exist?('hoge.sass') { true }
      end

      it 'should sassize *.sass' do
        mock(middleware).sassize('hoge.sass') { 'sass' }
        subject
      end
    end

    context 'neighter exists' do
      before do
        stub(File).exist?(path) { false }
        stub(File).exist?('hoge.sass') { false }
      end

      it 'should move on to next app' do
        mock(app).call(env)
        subject
      end
    end
  end

  context 'for *.sass' do
    let(:path) { 'hoge.sass' }

    context 'when *.sass exists' do
      it_should_behave_like 'sassize PATH_INFO'
    end

    context '*.sass does not exist' do
      before do
        stub(File).exist?(path) { false }
      end

      it 'should move on to next app' do
        mock(app).call(env)
        subject
      end
    end
  end
end
