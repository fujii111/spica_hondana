module EvaluationHelper
  def num2evalution(num)
    result = ''
    if num == 3
      result = '悪い'
    elsif num ==2
      result = '普通'
    else
      result = '良い'
    end
    result
  end
end
