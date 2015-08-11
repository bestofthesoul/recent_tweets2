
get '/' do
  erb :index
end

#FIRST STEP: RETRIEVE ALL TWEETS NO MATTER WHAT
# get '/:username' do
#   @twitter_user = TwitterUser.find_or_create_by(username: params[:username])
#   @tweets = $client.user_timeline(params[:username])  
#   @tweets.each do |tweet|
#     @twitter_user.tweets.create(text: tweet.text)
#   end
# end

#SECOND STEP, RETRIEVE ALL TWEETS ONLY FROM TWITTER SERVER IF ITS EMPTY OR LAST TWEET AINT LAST TWEET
get '/:username' do

  @twitter_user = TwitterUser.find_or_create_by(username: params['username'])
  @tweets = @twitter_user.tweets
  #WHEN EMPTY
  if @tweets.empty?
    @tweets = $client.user_timeline(params[:username], count: 5)
    @tweets.each do |tweet|
      @twitter_user.tweets.create(text: tweet.text)
    end
  #WHEN NOT EMPTY AND ITS VALID (LAST TWEET-DATABASE IS LAST TWEET-TWITTER SERVER)
  elsif @tweets.last.still_valid?
      @tweets = @twitter_user.tweets.all
  #WHEN NOT EMPTY BUT LAST TWEET AINT LAST TWEET
  else
    # GEM DEFAULT IS 20 TWEETS
    @twitter_user.tweets.destroy_all
    @tweets = $client.user_timeline(params[:username], count: 5)
    
    @tweets.each do |tweet|
      @twitter_user.tweets.create(text: tweet.text)
    end
  
  endSS

  erb :index
end


post '/' do
  redirect "/#{params[:username]}"
end


