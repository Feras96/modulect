class TagsController < ApplicationController

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tags_params)
    # Save the object
    if @tag.save
      # If save succeeds, redirect to the index action
      flash[:notice] = @tag.name+" was created successfully."
      redirect_to(tags_path)
    else
      # If save fails, redisplay the form so user can fix problems
      render('new')
    end
  end

  def update
    # Find a new object using form parameters
    @tag = Tag.find(params[:id])
    # Update the object
    if @tag.update_attributes(tags_params)
      # If save succeeds, redirect to the show action
      flash[:notice] = @tag.name+" was updated successfully."
      redirect_to(tag_path(@tag))
    else
      # If save fails, redisplay the form so user can fix problems
      render('edit')
    end
  end


end
