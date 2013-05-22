class TianyaController < ApplicationController

	require 'oauth2'
	require 'digest/md5'
	require 'uri'

	def create_timestamp
		Time.now.to_i
	end

	def create_md5
		rand = rand() + create_timestamp
		Digest::MD5.hexdigest(rand.to_s)
	end

	def get_request_token
		appkey = 'fc69b18eb12bab1e9b35d1093c4de9290516cfdc4' 
		appsecret = '00916893840fe0a29dfdc261efd3a26a&'
		callback = CGI::escape("http://open.tianya.cn/oauth/request_token.php")

		oauth_consumer_key = CGI::escape('oauth_consumer_key')+'%3D'+CGI::escape(appkey)+'%26'
		oauth_nonce = CGI::escape('oauth_nonce')+'%3D'+CGI::escape(create_md5)+'%26'
		oauth_signature_method = CGI::escape('oauth_signature_method')+'%3D'+CGI::escape('HMAC-SHA1')+'%26'
		oauth_timestamp = CGI::escape('oauth_timestamp')+'%3D'+CGI::escape(create_timestamp.to_s)+'%26'
		oauth_version = CGI::escape('oauth_version')+'%3D'+CGI::escape('1.0')

		basestr = 'GET&'+callback+'&'+oauth_consumer_key+oauth_nonce+oauth_signature_method+oauth_timestamp+oauth_version
		puts '---------------------'
		puts basestr
		puts '---------------------'
		signature = Base64.encode64 OpenSSL::HMAC.hexdigest("sha1",appsecret,basestr)
		signature.delete("\n")
		puts '---------------'
		puts signature
		puts '---------------'

		url = 'oauth_consumer_key='+appkey+'&'+
			'oauth_nonce='+CGI::escape(create_md5)+'&'+
			'oauth_signature_method='+'HMAC-SHA1'+'&'+
			'oauth_timestamp='+create_timestamp.to_s+'&'+
			'oauth_version='+'1.0'+'&'+
			'oauth_signature='+signature

		puts '------------------'
		puts url
		puts '------------------'

		oauth_ts = open 'http://open.tianya.cn/oauth/request_token.php?'+url#or oauth_ts = oauth_ts.read
		ots = Rack::Utils.parse_nested_query(aouth_ts)
		oauth_token = ots['oauth_token']
		oauth_token_secret = ots['oauth_token_secret']

		session[:oauth_token] = oauth_token
		session[:oauth_token_secret] = oauth_token_secret


	end

	def get_access_token
		
	end



end

