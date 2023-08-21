module ResponseHelper
  def success_response(data, status = :ok)
    render json: data, status:
  end

  def error_response(error, status = :unprocessable_entity)
    render json: { error: }, status:
  end
end
