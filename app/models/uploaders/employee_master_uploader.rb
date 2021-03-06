class EmployeeMasterUploader
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include Uploader
  HEADERS = ["code", "name", "designation_name", "department_name", "father_or_husband_name", "relation", "gender", "date_of_birth", "email","initials", "qualification", "date_of_joining", "probation_date", "confirmation_date", "resignation_date", "reason_for_resignation", "p_f_no", "bank_name", "account_number", "pan", "ctc", "basic"]
  
  def persisted?
    false
  end

  def initialize(params = {})
    super(params[:file])
  end

  def save
    super do |row, params={}|
      row_hash = row.to_hash.slice(*headers_to_show)
      employee_master = EmployeeMaster.find_by_code(map_row_data(row_hash)["code"]) || EmployeeMaster.new
      employee_master.attributes = valid_attributes(map_row_data(row_hash))
      employee_master.designation_master = employee_master.designation_from_params
      employee_master.department_master = employee_master.department_from_params
      employee_master.ctc = employee_master.ctc.to_i
      employee_master.basic = employee_master.basic.to_i
      employee_master.account_number = employee_master.account_number.to_i.to_s
      employee_master
    end
  end

  def headers_to_show
    HEADERS.map{|key| key_to_show(key)}
  end

  def map_row_data(row_hash)
    HEADERS.map{|key| [key, row_hash[key_to_show(key)]]}.to_h
  end

  def valid_attributes(row_hash)
    row_hash.select{|key, val| val.present?}
  end

  def key_to_show(key)
    if ["pan", "ctc"].include? key
      key.titleize.upcase 
    else
      key.titleize
    end
  end

  def xls_template(options = {})
    CSV.generate(options) do |csv|
      csv << headers_to_show
    end
  end

end
