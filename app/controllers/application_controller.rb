class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  def production?
    Rails.env.production?
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :family_name_kanji, :first_name_kanji, :family_name_kana, :first_name_kana, :birthday_y_m_d])
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials[:basic_auth][:user] &&
      password == Rails.application.credentials[:basic_auth][:pass]
    end
  end
  
  def self.zenkaku?(str)
    return nil if str.nil?
    # 全角のみOKなので、半角が混ざっているとfalseが返る
    unless str.to_s =~/^[^ -~｡-ﾟ]*$/
      return false
    end
    return true
  end
end
