require 'base64'
require 'digest/md5'
require 'twitpic'

class HamsketchController < ApplicationController

  def putImage
    img = params[:img]
	p "img = " + img
	decoded_img = Base64.decode64(img)
	p "decoded_img = " + decoded_img
	if img
	   file_name = Digest::MD5.new.update(img).to_s() + ".jpeg"
	   File.open("public/images/sketch/" + file_name, "wb") {|f| f.write(decoded_img)}
	end
    twitpic = TwitPic::Client.new
    twitpic.configure do |conf|
      conf.api_key =         Rails.application.config.base['platforms']['twitpic']['api_key']
      conf.consumer_key =    Rails.application.config.base['platforms']['twitpic']['consumer_key']
	  conf.consumer_secret = Rails.application.config.base['platforms']['twitpic']['consumer_secret']
	  conf.oauth_token =     Rails.application.config.base['platforms']['twitpic']['access_token']
      conf.oauth_secret =    Rails.application.config.base['platforms']['twitpic']['access_token_secret']
    end
    media = twitpic.upload("public/images/sketch/" + file_name, params[:message])
    return render :json => { :file_name => file_name, :pic_url => media["url"] }.to_json
  end
end

class PicTwit
  access_token = nil
  twitpic_api_key = nil

  def initialize(con_key,con_secret,ac_token,ac_token_secret,api_key)
    access_token = SimpleOAuth.new(con_key,con_secret,ac_token,ac_token_secret)
    twitpic_api_key = api_key
  end

  def add_oauth_echo_heder(request,realm_url,auth_provider_url)
    auth = access_token.make_auth_header(:GET, auth_provider_url)
    request["X-Auth-Service-Provider"] = auth_provider_url
    request["X-Verify-Credentials-Authorization"] = auth + ", realm=\"#{realm_url}\""
  end

  def add_form_body(body_array,boundary,key,value)
    body_array << "--#{boundary}"
    body_array << "Content-Disposition: form-data; name=\"#{key}\""
    body_array << ""
    value.split(/\n/).each{|line|
      body_array << "#{line}"
    }
  end

  def mime_type(file)
    case
      when file =~ /\.jpg/ then 'image/jpg'
      when file =~ /\.gif$/ then 'image/gif'
      when file =~ /\.png$/ then 'image/png'
      else 'application/octet-stream'
    end
  end

  def add_file_body(body_array,boundary,key,file_path)
    file_name = File.basename(file_path)
    mime_type = mime_type(file_name)
    body_array << "--#{boundary}"
    body_array << "Content-Disposition: form-data; name=\"#{key}\"; filename=\"#{file_name}\""
    body_array << "Content-Type: #{mime_type}"
    body_array << ""

    open(file_path){|io|
	  body_array << io.read
    }
  end

  def twitpic_upload(image_file_path, message = "")
    twitpic_api_url = "http://api.twitpic.com/2/upload.json"
    realm_url = "http://api.twitter.com/"
    auth_provider_url = "https://api.twitter.com/1/account/verify_credentials.json"

    url_token = URI.parse(twitpic_api_url)
    request = Net::HTTP::Post.new(url_token.request_uri)

    # construct HTTP request
    boundary = Time.now.strftime("%Y%m%d_%H%M%S_#{$$}")

    # OAuth Echo
    add_oauth_echo_heder(request,realm_url,auth_provider_url)

    #Content-Type
    request["Content-Type"] = "multipart/form-data; boundary=#{boundary}"

    body_part = []
    add_form_body(body_part,boundary,'key',twitpic_api_key)
    add_form_body(body_part,boundary,'message',message) if(message!="")
    add_file_body(body_part,boundary,'media',image_file_path)
    body_part << "--#{boundary}--"
    body_part << ""
    request.body = body_part.join("\r\n")
    request["Content-Length"] = request.body.size

    begin
      http = Net::HTTP.new(url_token.host, url_token.port).start
      response = http.request(request)

      retrun_message=JSON.parse(response.body)
      return nil  if (retrun_message['text'] != message)
	  return retrun_message
    rescue => err
      time = Time.now.strftime("%Y/%m/%d %H:%M:%S")
      STDERR.print "#{time}\t[Error:upload_twitpic]\t #{err}\n"
    end
  end

end