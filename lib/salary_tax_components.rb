module SalaryTaxComponents

  def basic
    payslips.inject(0){|sum, payslip| sum + payslip.basic.to_i}
  end

  def hra
    payslips.inject(0){|sum, payslip| sum + payslip.hra.to_i}
  end

  def conveyance_allowance
    payslips.inject(0){|sum, payslip| sum + payslip.conveyance_allowance.to_i}
  end

  def city_compensatory_allowance
    payslips.inject(0){|sum, payslip| sum + payslip.city_compensatory_allowance.to_i}
  end

  def special_allowance
    payslips.inject(0){|sum, payslip| sum + payslip.special_allowance.to_i}
  end

  def loyalty_allowance
    payslips.inject(0){|sum, payslip| sum + payslip.loyalty_allowance.to_i}
  end

  def leave_settlement
    payslips.inject(0){|sum, payslip| sum + payslip.leave_settlement.to_i}
  end

  def medical_allowance
    payslips.inject(0){|sum, payslip| sum + payslip.medical_allowance.to_i}
  end

  def other_payment
    payslips.inject(0){|sum, payslip| sum + payslip.annual_bonus.to_i}
  end

  def pf
    payslips.inject(0){|sum, payslip| sum + payslip.pf.to_i}
  end


  def tds_pm
    payslips.inject(0){|sum, payslip| sum + (payslip.approved? ? payslip.tds_pm.to_i : 0)}
  end

  def professional_tax
    payslips.inject(0){|sum, payslip| sum + payslip.professional_tax.to_i}
  end

  def total_earnings
    basic + hra + conveyance_allowance + city_compensatory_allowance + special_allowance + loyalty_allowance + leave_settlement + medical_allowance + other_payment
  end


  def payslips
    if employee_master.present?
      @payslips ||= financial_year_payslips
    else
      []
    end
  end

  def existed_payslips
    employee_master.payslips.generated_between(financial_year_from, financial_year_to)
  end

  def financial_year_payslips
    payslips = []
    existed_payslips = existed_payslips
    moving_month = financial_year_from
    next_fin_year_start_month = financial_year_to.next_month
    while(not (moving_month.strftime("%m") == next_fin_year_start_month.strftime("%m") and moving_month.strftime("%y") == next_fin_year_start_month.strftime("%y")))
      if existed_payslips.present? and not existed_payslips.empty?
        payslip = existed_payslips.select{|payslip| payslip.generated_date.strftime("%m") == moving_month.strftime("%m") and payslip.generated_date.strftime("%y") == moving_month.strftime("%y")}.first
        if payslip.present?
          payslips << payslip
        else
          payslips << EmployeeNewPayslip.new(employee_master, moving_month).payslip(false)
        end
      else
        payslips << EmployeeNewPayslip.new(employee_master, moving_month).payslip(false)
      end
      moving_month = moving_month.next_month
    end
    payslips
  end

end
