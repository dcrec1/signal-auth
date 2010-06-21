require 'spec_helper'

class AuthController < ApplicationController
  def index
  end
end

ActionController::Routing::Routes.draw do |map|
  map.connect '/test', :controller => :auth, :action => :index
  map.connect '/build', :controller => :builds, :action => :create
end

def authorization_for(user, password)
  "Basic " + Base64::encode64("#{user}:#{password}")
end

describe AuthController do
  it "should require authentication" do
    get :index 
    response.code.should eql("401")
  end

  context "with good data" do
    it "should execute the action" do
      @request.env["HTTP_AUTHORIZATION"] = authorization_for("admin", "admin@signal")
      get :index
      response.code.should eql("200")
    end
  end

  context "with wrong data" do
    context "password" do
      it "should not execute the action" do
        @request.env["HTTP_AUTHORIZATION"] = authorization_for("admin", "wrong")
        get :index
        response.code.should eql("401")
      end
    end

    context "user" do
      it "should not execute the action" do
        @request.env["HTTP_AUTHORIZATION"] = authorization_for("wrong", "admin@signal")
        get :index
        response.code.should eql("401")
      end
    end
  end
end

describe BuildsController do
  before :each do
    controller.stub!(:create).and_return(true)
  end

  it "should create a build without authenticating the user" do
    post :create
    response.should be_success
  end

  it "should create a build with verifying the authenticity token" do
    controller.should_not_receive(:verify_authenticity_token)
    post :create
  end
end
