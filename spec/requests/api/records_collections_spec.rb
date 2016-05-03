require "request_helper"

describe Api do
  fixtures :all
  before {
    @user = users :foo
    @first_folio = records_collections :foo
  }
  describe "GET /api/v1/collections" do

    it "returns all folios for user" do
      get "/api/v1/collections.json?access_token=#{@user.authentication_token}"

      parse_json = parse_response response
      parse_json['status'].should == 'success'
      parse_json['data'].size.should == 2
    end
  end

  describe "GET /api/v1/collections/:id" do

    it "returns specific folio for user" do
      get "/api/v1/collections/#{@first_folio.id}.json?access_token=#{@user.authentication_token}"

      parse_json = parse_response response
      parse_json['status'].should == 'success'
      parse_json['data']['name'].should == @first_folio.name
    end
  end

  describe "POST /api/v1/collections" do

    it "create a new folio for user" do
      post "/api/v1/collections.json?access_token=#{@user.authentication_token}", {name: 'Test folio for user'}

      parse_json = parse_response response
      parse_json['status'].should == 'success'
      parse_json['data']['name'].should == 'Test folio for user'
    end
  end

  describe "PUT /api/v1/collections/:id" do

    it "update folio" do
      put "/api/v1/collections/#{@first_folio.id}.json?access_token=#{@user.authentication_token}", {name: 'Test folio for user(changed)'}

      parse_json = parse_response response
      parse_json['status'].should == 'success'
      parse_json['data']['name'].should == 'Test folio for user(changed)'
    end
  end

  describe "DELETE /api/v1/collections/:id" do

    it "delete folio" do
      delete "/api/v1/collections/#{@first_folio.id}.json?access_token=#{@user.authentication_token}"

      parse_json = parse_response response
      parse_json['status'].should == 'success'
      parse_json['data']['name'].should == 'test collection 1'
    end
  end

  describe "POST /api/v1/collections/:id/record.json" do
    before {
      @record_foo_1 = records :foo_1
    }

    it "add record to collection" do
      post "/api/v1/collections/#{@first_folio.id}/record.json?access_token=#{@user.authentication_token}", {record_id: @record_foo_1.id}

      parse_json = parse_response response
      parse_json['status'].should == 'success'

      $stderr.puts parse_json

      parse_json['data']['name'].should == 'test collection 1'
      parse_json['data']['records'].size.should == 3
    end
  end

  describe "DELETE /api/v1/collections/:id/record.json" do
    before {
      @record_foo_1 = records :foo_1
    }

    it "add record to collection" do
      post "/api/v1/collections/#{@first_folio.id}/record.json?access_token=#{@user.authentication_token}", {record_id: @record_foo_1.id}

      parse_json = parse_response response
      parse_json['status'].should == 'success'
      parse_json['data']['name'].should == 'test collection 1'
      parse_json['data']['records'].size.should == 2
    end
  end
end