#!/usr/bin/ruby

#  supremo.rb
#  Supremo
#
#  Created by Jamie Cho on 7/23/12.
#  Copyright 2012 Jamie Cho. All rights reserved.

require "gosu"
require "texplay"
require "json"

class Win < Gosu::Window
    def initialize(width, height, full_screen = false)
        super(width, height, full_screen)
        @objects = []
        nil
    end
    
    def line(x0, y0, x1, y1, color)
        @objects << [:line, x0, y0, x1, y1, color]
        nil
    end
    
    def ftriangle(x0, y0, x1, y1, x2, y2, color)
        @objects << [:ftriangle, x0, y0, x1, y1, x2, y2, color]
        nil
    end
    
    def triangle(x0, y0, x1, y1, x2, y2, color)
        @objects << [:triangle, x0, y0, x1, y1, x2, y2, color]
        nil
    end
    
    def fquad(x0, y0, x1, y1, x2, y2, x3, y3, color)
        @objects << [:fquad, x0, y0, x1, y1, x2, y2, x3, y3, color]
        nil
    end
    
    def quad(x0, y0, x1, y1, x2, y2, x3, y3, color)
        @objects << [:quad, x0, y0, x1, y1, x2, y2, x3, y3, color]
        nil
    end

    def circle(x, y, r, color, hw = 1, s = 0, e = 1, divisions = 100)
        @objects << [:circle, x, y, r, color, hw, s, e, divisions]
        nil
    end
    
    def fcircle(x, y, r, color, hw = 1, s = 0, e = 1, divisions = 100)
        @objects << [:fcircle, x, y, r, color, hw, s, e, divisions]
        nil
    end
    
    def clear(color)
        @objects = []
        @objects << [:clear, color]
        nil
    end
    
    def draw
        @objects.each do |obj|
            begin
                type = obj[0]
                self.draw_triangle 0, 0, Gosu::Color::YELLOW, 100, 100, Gosu::Color::BLUE, 300, 300, Gosu::Color::GREEN, 1
                if (type == :line)
                    self.draw_line obj[1], obj[2], obj[5], obj[3], obj[4], obj[5], 0
                elsif (type == :ftriangle)
                    self.draw_quad obj[1], obj[2], obj[7], obj[3], obj[4], obj[7], obj[5], obj[6], obj[7], obj[5], obj[6], obj[7], 0
                elsif (type == :triangle)
                    self.draw_line obj[1], obj[2], obj[7], obj[3], obj[4], obj[7], 0
                    self.draw_line obj[3], obj[4], obj[7], obj[5], obj[6], obj[7], 0
                    self.draw_line obj[5], obj[6], obj[7], obj[1], obj[2], obj[7], 0
                elsif (type == :fquad)
                    self.draw_quad obj[1], obj[2], obj[9], obj[3], obj[4], obj[9], obj[5], obj[6], obj[9], obj[7], obj[8], obj[9], 0
                elsif (type == :quad)
                    self.draw_line obj[1], obj[2], obj[9], obj[3], obj[4], obj[9], 0
                    self.draw_line obj[3], obj[4], obj[9], obj[5], obj[6], obj[9], 0
                    self.draw_line obj[5], obj[6], obj[9], obj[7], obj[8], obj[9], 0
                    self.draw_line obj[7], obj[8], obj[9], obj[1], obj[2], obj[9], 0
                elsif (type == :circle)
                    draw_circle(obj[1], obj[2], obj[3], obj[4], obj[5], obj[6], obj[7], obj[8])
                elsif (type == :fcircle)
                    draw_fcircle(obj[1], obj[2], obj[3], obj[4], obj[5], obj[6], obj[7], obj[8])
                elsif (type == :clear)
                    self.draw_quad 0, 0, obj[1], width, 0, obj[1], width, height, obj[1], 0, height, obj[1], 0
                end
            rescue Exception=>ex
            end
        end
    end
    
    def draw_circle(x, y, r, color, hw = 1, s = 0, e = 1, divisions = 100)
        # Take care of strange cases
        s = s.abs
        e = e.abs
        if (((s - e).abs >= 1) || (s == e))
            s = 0
            e = 1
        end
        ds = s - ((s > 1) ? s % 1 : s)
        s = s - ds
        e = e - ds
        e = 1 + e if (e < s)

        # Compute the angle step size and the start and stop points
        step_size = (2 * Math::PI)/divisions
        start_index = (divisions * s).to_i
        end_index = (0.5 + divisions * e).to_i
        
        # Draw the circle
        angle = step_size * start_index
        x0 = x + r * Math.cos(angle)
        y0 = y + hw * r * Math.sin(angle)
        ((start_index+1)..end_index).each do |ii|
            angle = step_size * ii
            x1 = x + r * Math.cos(angle)
            y1 = y + hw * r * Math.sin(angle)
            self.draw_line x0, y0, color, x1, y1, color
            x0 = x1
            y0 = y1
        end
    end
    
    def draw_fcircle(x, y, r, color, hw = 1, s = 0, e = 1, divisions = 100)
        # Take care of strange cases
        s = s.abs
        e = e.abs
        if (((s - e).abs >= 1) || (s == e))
            s = 0
            e = 1
        end
        ds = s - ((s > 1) ? s % 1 : s)
        s = s - ds
        e = e - ds
        e = 1 + e if (e < s)
        
        # Compute the angle step size and the start and stop points
        step_size = (2 * Math::PI)/divisions
        start_index = (divisions * s).to_i
        end_index = (0.5 + divisions * e).to_i
        
        # Draw the circle
        angle = step_size * start_index
        x0 = x + r * Math.cos(angle)
        y0 = y + hw * r * Math.sin(angle)
        ((start_index+1)..end_index).each do |ii|
            angle = step_size * ii
            x1 = x + r * Math.cos(angle)
            y1 = y + hw * r * Math.sin(angle)
            self.draw_quad x, y, color, x0, y0, color, x1, y1, color, x1, y1, color, 0
            x0 = x1
            y0 = y1
        end
    end
    
    def save(filename)
        json = JSON::unparse @objects
        File.open filename, 'w' do |f|
            f.write json
        end
    end
    
    def load(filename)
        color_regex = /^\(ARGB\:\ ([0-9]+)\/([0-9]+)\/([0-9]+)\/([0-9]+)/
        json = IO.read(filename)
        objects = JSON::parse(json)
        objects.each do |obj|
            obj[0] = obj[0].to_sym
            (1..obj.length).each do |ii|
                param = obj[ii]
                if (param.kind_of? String)
                    match = color_regex.match param
                    if (match != nil)
                       obj[ii] = Gosu::Color.new(match[1].to_i, match[2].to_i, match[3].to_i,match[4].to_i)
                    end
                end
            end
        end
        @objects = objects
        nil
    end
end

def make_win(width, height)
    foo = Win.new(width, height)
    Thread.new do
        foo.show
    end
    foo
end
