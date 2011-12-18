require 'spec_helper'

shared_examples_for 'hamlize PATH_INFO' do
  before do
    stub(File).exist?(file) { true }
  end
  
  it 'should hamlize PATH_INFO' do
    mock(middleware).hamlize(file) { 'haml' }
    subject
  end
end

shared_examples_for 'sassize PATH_INFO' do
  before do
    stub(File).exist?(file) { true }
  end
  
  it 'should hamlize PATH_INFO' do
    mock(middleware).sassize(file) { 'sass' }
    subject
  end
end

describe Mascut::Hamlth, '#call' do
  let(:app) { mock }
  let(:middleware) { Mascut::Hamlth.new(app) }
  let(:env) { { 'PATH_INFO' => path } }
  let(:file) { path[1..-1] }
  
  subject { middleware.call(env) }
  
  context 'for *.html' do
    let(:path) { '/hoge.html' }

    context 'when *.html exists' do
      it_should_behave_like 'hamlize PATH_INFO'
    end

    context 'when *.haml exists' do
      before do
        stub(File).exist?(file) { false }
        stub(File).exist?('hoge.haml') { true }
      end

      it 'should hamlize *.haml' do
        mock(middleware).hamlize('hoge.haml') { 'haml' }
        subject
      end
    end

    context 'neighter exists' do
      before do
        stub(File).exist?(file) { false }
        stub(File).exist?('hoge.haml') { false }
      end

      it 'should move on to next app' do
        mock(app).call(env)
        subject
      end
    end
  end

  context 'for *.haml' do
    let(:path) { '/hoge.haml' }
    let(:file) { path[1..-1] }

    context 'when *.haml exists' do
      it_should_behave_like 'hamlize PATH_INFO'
    end

    context '*.haml does not exist' do
      before do
        stub(File).exist?(file) { false }
      end

      it 'should move on to next app' do
        mock(app).call(env)
        subject
      end
    end
  end

  context 'for *.css' do
    let(:path) { '/hoge.css' }
    let(:file) { path[1..-1] }
    
    context 'when *.css exists' do
      it_should_behave_like 'sassize PATH_INFO'
    end

    context 'when *.sass exists' do
      before do
        stub(File).exist?(file) { false }
        stub(File).exist?('hoge.sass') { true }
      end

      it 'should sassize *.sass' do
        mock(middleware).sassize('hoge.sass') { 'sass' }
        subject
      end
    end

    context 'neighter exists' do
      before do
        stub(File).exist?(file) { false }
        stub(File).exist?('hoge.sass') { false }
      end

      it 'should move on to next app' do
        mock(app).call(env)
        subject
      end
    end
  end

  context 'for *.sass' do
    let(:path) { '/hoge.sass' }
    let(:file) { path[1..-1] }

    context 'when *.sass exists' do
      it_should_behave_like 'sassize PATH_INFO'
    end

    context '*.sass does not exist' do
      before do
        stub(File).exist?(file) { false }
      end

      it 'should move on to next app' do
        mock(app).call(env)
        subject
      end
    end
  end
end
