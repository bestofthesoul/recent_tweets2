get '/' do
  erb :index
end

get '/:username' do
  @twitter_user = TwitterUser.find_or_create_by(username: params['username'])
  @tweets = @twitter_user.tweets

  if @tweets.empty?
    @twitter_user.fetch_tweets(params['username'])
  elsif @tweets.last.still_valid?
    @tweets = @twitter_user.tweets.all
  else
    @twitter_user.fetch_tweets(params['username'])
  end
  erb :tweet_show

end


post '/username' do
  redirect to "/#{params[:username]}"
end


post '/' do
  $client.update(params[:newtweet])
  @twitter_user = TwitterUser.find_or_create_by(username: params['username'])
  @twitter_user.fetch_tweets(params['username'])
  @tweets = @twitter_user.tweets

# LAYOUT SET FALSE TO REMOVE THE CONTAINER WHEN I INSERTED INTO DIV ID =" TWEETS"
  erb :_tweet_box, layout: false
end



