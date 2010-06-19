require 'spec_helper'

class AuthController < ApplicationController
  def index
  end
end

ActionController::Routing::Routes.draw do |map|
  map.connect '/test', :controller => :auth, :action => :index
  map.connect '/build', :controller => :projects, :action => :build
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

describe ProjectsController do
  it "should not require authentication for build" do
    Project.stub!(:find).and_return(mock(Project, :send_later => nil))
    get :build
    response.should be_success
  end
end
