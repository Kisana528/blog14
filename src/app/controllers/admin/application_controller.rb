class Admin::ApplicationController < ApplicationController
  before_action :admin_account
  private
end