class JobRun < ActiveRecord::Base
  PAYSLIP_MAILING = "payslip_mailing"
  PF_STATEMENT = "pf_statement"
  
  has_many :pf_statements

  scope :matching_code, lambda {|code| where(:job_code => code)}
  scope :on_date, lambda{|date| where(:job_date => date)}
  scope :in_the_current_month, lambda{|date| in_the_month(date.strfitime("%b").in_the_year(date.strftime("%Y")))}
  scope :in_the_year, lambda{|year| where("to_char(job_date, 'YYYY') = ?", year)}
  scope :in_the_month, lambda{|month| where("to_char(job_date, 'Mon') = ?", month[0..2])}

  def self.schedule(job_code, scrolled_by, job_date)
    run = JobRun.new(job_code: job_code, scrolled_by: scrolled_by, started_on: DateTime.now, status: "scheduled", job_date: job_date)
    yield run if block_given?
    run.save
    run
  end
  
  def self.finish_as_success(job_run_id)
    finish_as(job_run_id, 'success')
  end

  def self.finish_as_error(job_run_id)
    finish_as(job_run_id, 'error')
  end
  
  def self.finish_as_failed(job_run_id)
    finish_as(job_run_id, 'failed')
  end

  def self.finish_as(job_run_id, status)
    job_run = JobRun.find(job_run_id)
    job_run.finish_run_as(status)
  end
  
  def finish_run_as(status)
    update_attributes(status: status, finished_on: DateTime.now)
  end

  def scheduled?
    status == "scheduled"
  end

  def finished?
    status == "success"
  end
end
