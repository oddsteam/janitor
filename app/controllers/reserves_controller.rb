class ReservesController < ApplicationController
  before_action :isLogin
  before_action :set_reserf, only: %i[ show edit update destroy ]
  attr_reader :selected_date

  def index
    @getEmail = Reserve.get_email_form_session(session)
    @getUserId = Reserve.get_userId_form_session(session)
    @selected_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @alert_message = ""

    dateNext3Month = Date.today + 3.month
    if @selected_date > dateNext3Month
      @selected_date = dateNext3Month
      @alert_message = "Maximum date is 3 months from now"
    elsif @selected_date < Date.today
      @selected_date = Date.today
      @alert_message = "You can't select the past date"
    end
    
    if params[:id].present?
      begin
        @reserve = Reserve.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to reserves_path
      end
    end

    @reserves = Reserve.where(date: @selected_date).order(:start_timer)
    @this_user_bookings = Reserve.where(userId: @getUserId).where(date: @selected_date).order(:start_timer)
    @days_in_month = Date.new(@selected_date.year, @selected_date.month, -1).day
    @start_of_month = @selected_date.beginning_of_month.wday

    @rooms = [
      { id: 1, room_name: "Meeting 1", room_address: "Binary Base", seat: 3, room_description: "Small meeting room" },
      { id: 2, room_name: "Meeting 2", room_address: "Binary Base", seat: 6, room_description: "Medium meeting room" },
      { id: 3, room_name: "Territory 1", room_address: "Binary Base", seat: 5, room_description: "Large meeting room" },
      { id: 4, room_name: "Territory 2", room_address: "Binary Base", seat: 5, room_description: "Extra large meeting room" },
      { id: 5, room_name: "Territory 3", room_address: "Binary Base", seat: 5, room_description: "Extra large meeting room" },
      { id: 6, room_name: "Global", room_address: "Binary Base", seat: 30, room_description: "Extra large meeting room" },
      { id: 7, room_name: "All Nighter 1", room_address: "Binary Base", seat: 36, room_description: "LeSSex Area" },
      { id: 8, room_name: "All Nighter 2", room_address: "Binary Base", seat: 32, room_description: "LeSSex Area" },
    ]
  end

  def update_selected_date
    if params[:date].present?
      @selected_date = Date.parse(params[:date])
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("calendar", partial: "calendar", locals: { selected_date: @selected_date, days_in_month: Date.new(@selected_date.year, @selected_date.month, -1).day, rooms: @rooms })
        end
        format.html { redirect_to reserves_path(date: @selected_date) }
      end
    else
      head :unprocessable_entity
    end
  rescue ArgumentError => error.message
    Rails.logger.error "Invalid date format: #{params[:date]}"
    head :unprocessable_entity
  end

  def show
  end

  def new
    @reserf = Reserve.new
  end

  def edit
  end

  def create
    @booking = Reserve.new(reserf_params)
    @booking.userId = Reserve.get_userId_form_session(session)

    respond_to do |format|
      if @booking.save
        @rooms = [
          { id: 1, room_name: "Meeting 1", room_address: "Binary Base", seat: 3, room_description: "Small meeting room" },
          { id: 2, room_name: "Meeting 2", room_address: "Binary Base", seat: 6, room_description: "Medium meeting room" },
          { id: 3, room_name: "Territory 1", room_address: "Binary Base", seat: 5, room_description: "Large meeting room" },
          { id: 4, room_name: "Territory 2", room_address: "Binary Base", seat: 5, room_description: "Extra large meeting room" },
          { id: 5, room_name: "Territory 3", room_address: "Binary Base", seat: 5, room_description: "Extra large meeting room" },
          { id: 6, room_name: "Global", room_address: "Binary Base", seat: 30, room_description: "Extra large meeting room" },
          { id: 7, room_name: "All Nighter 1", room_address: "Binary Base", seat: 36, room_description: "LeSSex Area" },
          { id: 8, room_name: "All Nighter 2", room_address: "Binary Base", seat: 32, room_description: "LeSSex Area" },
        ]
        format.turbo_stream
        format.json { render json: { status: 'success', notice: "Reserve was successfully created." }, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { status: 'error', errors: @booking.errors }, status: :unprocessable_entity }
      end
    end
  end

  def update
    uid = Page.get_userId_form_session(session)
    respond_to do |format|
      if @reserf.update(reserf_params.merge(userId: uid))
        format.html { redirect_to reserf_url(@reserf), notice: "Reserve was successfully updated." }
        format.json { render :show, status: :ok, location: @reserf }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reserf.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @reserf.destroy!

    respond_to do |format|
      format.html { redirect_to reserves_url, notice: "Reserve was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_reserf
    @reserf = Reserve.find(params[:id])
  end

  def reserf_params
    params.require(:reserve).permit(:date, :start_timer, :end_timer, :note, :roomId)
  end
end