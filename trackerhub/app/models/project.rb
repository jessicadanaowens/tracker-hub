class Project

  def self.all
    projects = get_projects
    projects = parse(projects)
    projects.map { |x| Project.new(x["name"]) }
    # make http request to the API
    # retrieve the response body of the API
  end

  def self.get_projects
    conn = Faraday.new(:url => 'https://www.pivotaltracker.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    response = conn.get  do |req|
      req.url '/services/v5/projects'
      req.headers['X-TrackerToken'] = ENV['TRACKER_TOKEN']
    end
    response.body
  end

  def self.parse(string)
    JSON.parse(string)
  end

  def initialize(name)
    @name = name
  end

  def name
    @name
  end
end