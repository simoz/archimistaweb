class UnitsController < ApplicationController

  def index
    @fond = Fond.find(params[:fond_id])
    @units = Unit.where("fond_id = ?", params[:fond_id]).includes(:preferred_event)
    @sequence_numbers = Unit.display_sequence_numbers_of(@fond.root)

    if pjax_request?
      render :list, :layout => false
    else
      if @units.size.zero?
        redirect_to fond_url(@fond)
      else
        redirect_to fond_unit_path(@fond, @units.first)
      end
    end
  end

  # OPTIMIZE: forse la route potrebbe essere non nested => units/:id anziché fond/:fond_id/units/:id
  def show
    @unit = Unit.find(params[:id])

    raise ActiveRecord::RecordNotFound if @unit.fond_id.to_i != params[:fond_id].to_i

    if pjax_request?
      render :description, :layout => false
    else
      @fond = Fond.select("id, name").find(params[:fond_id])
      @units = Unit.where("fond_id = ?", params[:fond_id])
      render "shared/treeview"
    end
  end

  def list
    @fond = Fond.find(params[:fond_id])
    @units = @fond.units.select('id, ancestry_depth, sequence_number, fond_id, title, reference_number').includes(:preferred_event)
    @sequence_numbers = Unit.display_sequence_numbers_of(@fond.root)
    render :layout => false
  end

  def description
    @unit = Unit.find(params[:id])
    render :layout => false
  end

end