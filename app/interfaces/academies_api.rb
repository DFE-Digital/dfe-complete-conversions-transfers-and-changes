class AcademiesApi

  include Singleton

  def initialize
    db = Sequel.sqlite

    db.create_table :projects do
      primary_key :id
      String :school_name
      Integer :urn
    end
    
    @projects = db[:projects]

    conversions_response = JSON.load_file('data/academy-conversions.json')

    conversions_response['data'].each do |project|
      @projects.insert(:id => project['id'], :urn => project['urn'], :school_name => project['schoolName'])
    end

  end

  def all_projects(urn)
    @projects.all
  end

  def find_projects_by_urn(urn)
    @projects.where(:urn => urn).all
  end
end
  