module Layouts

using Genie, Stipple, StipplePlotly
import Genie.Renderer.Html: HTMLString, normal_element, register_normal_element
using Requires

const LAYOUT_TITLE_REF_CONTAINER = "container"
const LAYOUT_TITLE_REF_PAPER = "paper"
const LAYOUT_AUTO = "auto"
const LAYOUT_LEFT = "left"
const LAYOUT_CENTER = "center"
const LAYOUT_RIGHT = "right"
const LAYOUT_TOP = "top"
const LAYOUT_MIDDLE = "middle"
const LAYOUT_BOTTOM = "bottom"
const LAYOUT_ORIENTATION_VERTICAL = "v"
const LAYOUT_ORIENTATION_HORIZONTAL = "h"
const LAYOUT_ITEMSIZING_TRACE = "trace"
const LAYOUT_ITEMSIZING_CONSTANT = "constant"
const LAYOUT_CLICK_TOGGLE = "toggle"
const LAYOUT_CLICK_TOGGLEOTHERS = "toggleothers"
const LAYOUT_HIDE = "hide"
const LAYOUT_SHOW = "show"
const LAYOUT_ABOVE = "above"
const LAYOUT_BELOW = "below"
const LAYOUT_OVERLAY = "overlay"
const LAYOUT_GROUP = "group"
const LAYOUT_STACK = "stack"

function optionals!(d::Dict, ptype::Any, opts::Vector{Symbol}) :: Dict
  for o in opts
    if getproperty(ptype, o) !== nothing
      d[o] = getproperty(ptype, o)
    end
  end

  d
end

#===#

Base.@kwdef mutable struct Font
  family::String = raw"'Open Sans', verdana, arial, sans-serif"
  size::Union{Int,Float64} = 12
  color::String = "#444"
end

function Font(fontsize::Union{Int,Float64})
  fs = Font()
  fs.size = fontsize
  return fs
end

Base.:(==)(x::Font, y::Font) = x.family == y.family && x.size == y.size && x.color == y.color

Base.hash(f::Font) = hash("$(f.family)$(f.size)$(f.color)")

Base.@kwdef mutable struct Protation
  lon::Union{Float64, Int64} = -234
  lat::Union{Float64, Int64} = -234
  roll::Union{Float64, Int64} = -234
end

function PRotation(lon::Union{Float64, Int64}, lat::Union{Float64, Int64}, roll::Union{Float64, Int64})
  pr = Protation()
  pr.lon = lon
  pr.lat = lat
  pr.roll = roll
  return pr
end

"""
      Mcenter()

-----------
# Properties
-----------
* `lat::Union{Float64, Int64}` - Sets the latitude of the map's center. For all projection types, the map's latitude center lies at the middle of the latitude range by default.
* `lon::Union{Float64, Int64}` - Sets the longitude of the map's center. By default, the map's longitude center lies at the middle of the longitude range for scoped projection and above `projection.rotation.lon` otherwise.
"""
Base.@kwdef mutable struct Mcenter
  lon::Union{Float64, Int64} = -234
  lat::Union{Float64, Int64} = -234
end

function MCenter(lon::Union{Float64, Int64}, lat::Union{Float64, Int64})
  mc = Mcenter()
  mc.lon = lon
  mc.lat = lat
  return mc
end

#===#
"""
    ColorBar()

----------
# Examples
----------

```
julia> 
```

-----------
# Properties
-----------
* `bgcolor::String` - Sets the color of padded area.
* `bordercolor::String` - Sets the axis line color. Default = `"#444"`
* `borderwidth::Int` - Sets the width (in px) or the border enclosing this color bar. Default = `0`
* `dtick::Union{Float64,Int,String}` - Sets the step in-between ticks on this axis. Use with `tick0`. Must be a positive number, or special strings available to "log" and "date" axes. If the axis `type` is "log", then ticks are set every 10^(n"dtick) where n is the tick number. For example, to set a tick mark at 1, 10, 100, 1000, ... set dtick to 1. To set tick marks at 1, 100, 10000, ... set dtick to 2. To set tick marks at 1, 5, 25, 125, 625, 3125, ... set dtick to log_10(5), or 0.69897000433. "log" has several special values; "L<f>", where `f` is a positive number, gives ticks linearly spaced in value (but not position). For example `tick0` = 0.1, `dtick` = "L0.5" will put ticks at 0.1, 0.6, 1.1, 1.6 etc. To show powers of 10 plus small digits between, use "D1" (all digits) or "D2" (only 2 and 5). `tick0` is ignored for "D1" and "D2". If the axis `type` is "date", then you must convert the time to milliseconds. For example, to set the interval between ticks to one day, set `dtick` to 86400000.0. "date" also has special values "M<n>" gives ticks spaced by a number of months. `n` must be a positive integer. To set ticks on the 15th of every third month, set `tick0` to "2000-01-15" and `dtick` to "M3". To set ticks every 4 years, set `dtick` to "M48"
* `exponentformat::String` - Determines a formatting rule for the tick exponents. For example, consider the number 1,000,000,000. If "none", it appears as 1,000,000,000. If "e", 1e+9. If "E", 1E+9. If "power", 1x10^9 (with 9 in a super script). If "SI", 1G. If "B", 1B. Default - `"B"`
* `len::Union{Float64,Int}` - Sets the length of the color bar This measure excludes the padding of both ends. That is, the color bar length is this length minus the padding on both ends.
* `lenmode::String` - Determines whether the length of the color bar is set in units of plot "fraction" or in "pixels". Use `len` to set the value.
* `minexponent::Int` - Hide SI prefix for 10^n if |n| is below this number. This only has an effect when `tickformat` is "SI" or "B". Default - `0`
* `nticks::Int` - Specifies the maximum number of ticks for the particular axis. The actual number of ticks will be chosen automatically to be less than or equal to `nticks`. Has an effect only if `tickmode` is set to "auto". Default - `0`
* `outlinecolor::String` - Sets the axis line color.
* `outlinewidth::Int` - Sets the width (in px) of the axis line.
* `separatethousands::Bool` - If "true", even 4-digit integers are separated
* `showexponent::Bool` - If "all", all exponents are shown besides their significands. If "first", only the exponent of the first tick is shown. If "last", only the exponent of the last tick is shown. If "none", no exponents appear.
* `showticklabels::Bool` - Determines whether or not the tick labels are drawn.
* `showtickprefix::Bool` - If "all", all tick labels are displayed with a prefix. If "first", only the first tick is displayed with a prefix. If "last", only the last tick is displayed with a suffix. If "none", tick prefixes are hidden.
* `showticksuffix::Bool` - Same as `showtickprefix` but for tick suffixes.
* `thickness::Int` - Sets the thickness of the color bar This measure excludes the size of the padding, ticks and labels.
* `thicknessmode::String` - Determines whether the thickness of the color bar is set in units of plot "fraction" or in "pixels". Use `thickness` to set the value.
* `tick0::Union{Float64,Int,String}` - Sets the placement of the first tick on this axis. Use with `dtick`. If the axis `type` is "log", then you must take the log of your starting tick (e.g. to set the starting tick to 100, set the `tick0` to 2) except when `dtick`=*L<f>* (see `dtick` for more info), where the axis starts at zero. If the axis `type` is "date", it should be a date string, like date data. If the axis `type` is "category", it should be a number, using the scale where each category is assigned a serial number from zero in the order it appears.
* `tickangle::Union{String,Int,Float64}` - Sets the angle of the tick labels with respect to the horizontal. For example, a `tickangle` of -90 draws the tick labels vertically.
* `tickcolor::String` - Sets the tick color.
* `tickformat::String` - Sets the tick label formatting rule using d3 formatting mini-languages which are very similar to those in Python. For numbers, see: https://github.com/d3/d3-format/tree/v1.4.5#d3-format. And for dates see: https://github.com/d3/d3-time-format/tree/v2.2.3#locale_format. We add two items to d3's date formatter: "%h" for half of the year as a decimal number as well as "%{n}f" for fractional seconds with n digits. For example, "2016-10-13 09:15:23.456" with tickformat "%H~%M~%S.%2f" would display "09~15~23.46"
* `tickformatstops::Dict` - Array of object where each object has one or more of the keys - "dtickrange", "value", "enabled", "name", "templateitemname"
* `ticklabeloverflow::String` - Determines how we handle tick labels that would overflow either the graph div or the domain of the axis. The default value for inside tick labels is "hide past domain". In other cases the default is "hide past div".
* `ticklabelposition::String` - Determines where tick labels are drawn relative to the ticks. Left and right options are used when `orientation` is "h", top and bottom when `orientation` is "v". Type: enumerated , one of ( "outside" | "inside" | "outside top" | "inside top" | "outside left" | "inside left" | "outside right" | "inside right" | "outside bottom" | "inside bottom" ) Default: "outside"
* `ticklabelstep::String` - Sets the spacing between tick labels as compared to the spacing between ticks. A value of 1 (default) means each tick gets a label. A value of 2 means shows every 2nd label. A larger value n means only every nth tick is labeled. `tick0` determines which labels are shown. Not implemented for axes with `type` "log" or "multicategory", or when `tickmode` is "array".
* `ticklen::Int` - Sets the tick length (in px). Type: number greater than or equal to 0 | Default: 5
* `tickmode::String` - Sets the tick mode for this axis. If "auto", the number of ticks is set via `nticks`. If "linear", the placement of the ticks is determined by a starting position `tick0` and a tick step `dtick` ("linear" is the default value if `tick0` and `dtick` are provided). If "array", the placement of the ticks is set via `tickvals` and the tick text is `ticktext`. ("array" is the default value if `tickvals` is provided). Type: enumerated , one of ( "auto" | "linear" | "array" ) Default: "array"
* `tickprefix::String` - Sets a tick label prefix. Type: string Default: ""
* `ticks::String` - Determines whether ticks are drawn or not. If "", this axis' ticks are not drawn. If "outside" ("inside"), this axis' are drawn outside (inside) the axis lines. Type: enumerated , one of ( "outside" | "inside" | "" ) Default: ""
* `ticksuffix::String` - Sets a tick label suffix. Type: string Default: ""
* `ticktext::Vector{String}` - Sets the text displayed at the ticks position via `tickvals`. Only has an effect if `tickmode` is set to "array". Used with `tickvals`. Type: vector of strings
* `tickvals::Vector{Float64}` - Sets the values at which ticks on this axis appear. Only has an effect if `tickmode` is set to "array". Type: vector of numbers
* `tickwidth::Int` - Sets the tick width (in px). Type: number greater than or equal to 0 | Default: 1
* `title_font::Font` - Sets this color bar's title font.
* `title_side::String` - Determines the location of the colorbar title with respect to the color bar. Defaults to "top" when `orientation` if "v" and defaults to "right" when `orientation` if "h".
* `title_text::String` - Sets the title of the color bar.
* `x::Float64` - Sets the x position of the color bar (in plot fraction). Defaults to 1.02 when `orientation` is "v" and 0.5 when `orientation` is "h". Type: number between or equal to -2 and 3
* `xanchor::String` - Sets this color bar's horizontal position anchor. This anchor binds the `x` position to the "left", "center" or "right" of the color bar. Defaults to "left" when `orientation` is "v" and "center" when `orientation` is "h". Type: enumerated , one of ( "auto" | "left" | "center" | "right" )
* `xpad::Int` - Sets the amount of padding (in px) along the x direction. Type: number greater than or equal to 0 | Default: 0
* `y::Float64` - Sets the y position of the color bar (in plot fraction). Defaults to 0.98 when `orientation` is "v" and 0.5 when `orientation` is "h". Type: number between or equal to -2 and 3
* `yanchor::String` - Sets this color bar's vertical position anchor This anchor binds the `y` position to the "top", "middle" or "bottom" of the color bar. Defaults to "middle" when `orientation` is "v" and "bottom" when `orientation` is "h". Type: enumerated , one of ("top" | "middle" | "bottom" )
* `ypad::Int` - Sets the amount of padding (in px) along the y direction. Type: number greater than or equal to 0 | Default: 10
"""
Base.@kwdef mutable struct ColorBar
  bgcolor::Union{String,Nothing} = nothing # "rgba(0,0,0,0)"
  bordercolor::Union{String,Nothing} = nothing # "#444"
  borderwidth::Union{Int,Nothing} = nothing # 0
  dtick::Union{Float64,Int,String,Nothing} = nothing
  exponentformat::Union{String,Nothing} = nothing # none" | "e" | "E" | "power" | "SI" | "B", default is B
  len::Union{Float64,Int,Nothing} = nothing # number greater than or equal to 0
  lenmode::Union{String,Nothing} = nothing # "fraction" | "pixels", default is fraction | Default: "fraction"
  minexponent::Union{Int,Nothing} = nothing # number greater than or equal to 0 | Default: 3
  nticks::Union{Int,Nothing} = nothing # number greater than or equal to 0 | Default: 0
  orientation::Union{String,Nothing} = nothing # "v" | "h", default is "v"
  outlinecolor::Union{String,Nothing} = nothing # "#444"
  outlinewidth::Union{Int,Nothing} = nothing # number greater than or equal to 0 | Default: 1
  separatethousands::Union{Bool,Nothing} = nothing # true | false, default is false
  showexponent::Union{String,Nothing} = nothing # "all" | "first" | "last" | "none", default is "all"
  showticklabels::Union{Bool,Nothing} = nothing # true | false, default is true
  showtickprefix::Union{String,Nothing} = nothing # "all" | "first" | "last" | "none", default is all
  showticksuffix::Union{String,Nothing} = nothing # "all" | "first" | "last" | "none", default is "all"
  thickness::Union{Int,Nothing} = nothing # number greater than or equal to 0 | Default: 30
  thicknessmode::Union{String,Nothing} = nothing # "fraction" | "pixels", default is fraction | Default: "pixels"
  tick0::Union{Float64,Int,String,Nothing} = nothing # number or categorical coordinate string
  tickangle::Union{String,Int,Float64,Nothing} = nothing # Default: "auto"
  tickcolor::Union{String,Nothing} = nothing # Default: "#444"
  tickfont::Union{Font,Nothing} = nothing # Font Struct
  tickformat::Union{String,Nothing} = nothing # string, default is ""
  tickformatstops::Union{Dict,Nothing} = nothing # Dict containing properties
  ticklabeloverflow::Union{String,Nothing} = nothing # "allow" | "hide past div" | "hide past domain"
  ticklabelposition::Union{String,Nothing} = nothing # "outside" | "inside" | "outside top" | "inside top" | "outside bottom" | "inside bottom", default is "outside"
  ticklabelstep::Union{Int,Nothing} = nothing # number greater than or equal to 1 | Default: 1
  ticklen::Union{Int,Nothing} = nothing # number greater than or equal to 0 | Default: 5
  tickmode::Union{String,Nothing} = nothing # "auto" | "linear" | "array", default is "array"
  tickprefix::Union{String,Nothing} = nothing # string, default is ""
  ticks::Union{String,Nothing} = nothing # "outside" | "inside" | "" | Default: ""
  ticksuffix::Union{String,Nothing} = nothing # string, default is ""
  ticktext::Union{Vector{String},Nothing} = nothing # Vector of strings
  tickvals::Union{Vector{Float64},Vector{Int},Nothing} = nothing
  tickwidth::Union{Int,Nothing} = nothing # number greater than or equal to 0 | Default: 1
  x::Union{Float64,Nothing} = nothing # 1.02
  xanchor::Union{String,Nothing} = nothing # "left" | "center" | "right", default is left
  xpad::Union{Int,Nothing} = nothing # 10
  yanchor::Union{String,Nothing} = nothing # "top" | "middle" | "bottom", default is middle
  ypad::Union{Int,Nothing} = nothing # 10
  # needs special treatment:
  title_font::Union{Font,Nothing} = nothing # Font()
  title_side::Union{String,Nothing} = nothing # LAYOUT_LEFT
  title_text::Union{String,Nothing} = nothing # ""
end

function Base.show(io::IO, cb::ColorBar)
  output = "ColorBar: \n"
  for f in fieldnames(typeof(cb))
    prop = getproperty(cb, f)
    if prop !== nothing
      output *= "$f = $prop \n"
    end
  end

  print(io, output)
end

function Base.Dict(cb::ColorBar)
  trace = Dict{Symbol, Any}()

  d = Dict{Symbol, Any}()
  (cb.title_text !== nothing) && (d[:text] = cb.title_text)
  (cb.title_font !== nothing) && (d[:font] = cb.title_font)
  (cb.title_side !== nothing) && (d[:side] = cb.title_side)
  (length(d) > 0) && (trace[:title] = d)

  optionals!(trace, cb, [
    :bgcolor, :bordercolor, :borderwidth, :dtick, :exponentformat, :len, :lenmode, :minexponent, :nticks, :orientation,
    :outlinecolor, :outlinewidth, :separatethousands, :showexponent, :showticklabels, :showtickprefix, :showticksuffix,
    :thickness, :thicknessmode, :tick0, :tickangle, :tickcolor, :tickfont, :tickformat, :tickformatstops, :ticklabeloverflow,
    :ticklabelposition, :ticklabelstep, :ticklen, :tickmode, :tickprefix, :ticks, :ticksuffix, :ticktext, :tickvals, :tickwidth,
    :x, :xanchor, :xpad, :yanchor, :ypad
  ])
end

function Stipple.render(cb::ColorBar, fieldname::Union{Symbol,Nothing} = nothing)
  Dict(cb)
end

function ColorBar(text, title_font_size::Union{Int,Float64}, side)
  cb = ColorBar()
  cb.title_text = text
  cb.title_font = Font(title_font_size)
  cb.title_side = side
  cb
end

#===#
"""
    ErrorBar()

----------
# Examples
----------

```
julia> error_x = ErrorBar(
    array = [1.2, 2.6, 3.1],
    type = "data"
)
```

-----------
# Properties
-----------
* `array::Vector{Float64}` - Sets the data corresponding the length of each error bar. Values are plotted relative to the underlying data.
* `arrayminus::Vector{Float64}` - Sets the data corresponding the length of each error bar in the bottom (left) direction for vertical (horizontal) bars Values are plotted relative to the underlying data.
* `color::String` - Sets the stoke color of the error bars.
* `symmetric::Bool` - Determines whether or not the error bars have the same length in both direction (top/bottom for vertical bars, left/right for horizontal bars.
* `thickness::Int` - Sets the thickness (in px) of the error bars. Type: greater than or equal to 0. Default: 2
* `traceref::Int` - Type: Integer greater than or equal to 0. Default: 0
* `tracerefminus::Int` - Type: Integer greater than or equal to 0. Default: 0
* `type::String` - Determines the rule used to generate the error bars. If "constant`, the bar lengths are of a constant value. Set this constant in `value`. If "percent", the bar lengths correspond to a percentage of underlying data. Set this percentage in `value`. If "sqrt", the bar lengths correspond to the square of the underlying data. If "data", the bar lengths are set with data set `array`. Type: enumerated , one of ( "percent" | "constant" | "sqrt" | "data" )
* `value::Float64` - Sets the value of either the percentage (if `type` is set to "percent") or the constant (if `type` is set to "constant") in the case of "constant" `type`. Type: greater than or equal to 0. Default: 10
* `valueminus::Float64` - Sets the value of either the percentage (if `type` is set to "percent") or the constant (if `type` is set to "constant") corresponding to the lengths of the error bars in the bottom (left) direction for vertical (horizontal) bars. Type: number greater than or equal to 0 | Default: 10
* `visible::Bool` - Determines whether or not this set of error bars is visible.
* `width::Int` - Sets the width (in px) of the cross-bar at both ends of the error bars. Type: greater than or equal to 0
"""
Base.@kwdef mutable struct ErrorBar
  array::Union{Vector{Float64},Nothing} = nothing # Vector of numbers
  arrayminus::Union{Vector{Float64},Nothing} = nothing # Vector of numbers
  color::Union{String,Nothing} = nothing # Color string
  copy_ystyle::Union{Bool,Nothing} = nothing # true | false
  symmetric::Union{Bool,Nothing} = nothing
  thickness::Union{Int,Nothing} = nothing # 2
  traceref::Union{Int,Nothing} = nothing # 0
  tracerefminus::Union{Int,Nothing} = nothing # 0
  type::Union{String,Nothing} = nothing # "percent" | "constant" | "sqrt" | "data"
  value::Union{Float64,Nothing} = nothing # 10
  valueminus::Union{Float64,Nothing} = nothing # 10
  visible::Union{Bool,Nothing} = nothing
  width::Union{Int,Nothing} = nothing # 0
end

function Base.show(io::IO, eb::ErrorBar)
  output = "Errorbar: \n"
  for f in fieldnames(typeof(eb))
    prop = getproperty(eb, f)
    if prop !== nothing
      output *= "$f = $prop \n"
    end
  end

  print(io, output)
end

function ErrorBar(error_array::Vector; color::Union{String,Nothing} = nothing)
  eb = ErrorBar(visible=true, array=error_array, type="data", symmetric=true)
  (color !== nothing) && (eb.color = color)
  eb
end

function ErrorBar(error_array::Vector, error_arrayminus::Vector; color::Union{String,Nothing} = nothing)
  eb = ErrorBar(visible=true, array=error_array, type="data", symmetric=false, arrayminus=error_arrayminus)
  (color !== nothing) && (eb.color = color)
  eb
end

function ErrorBar(error_value::Number; color::Union{String,Nothing} = nothing)
  eb = ErrorBar(visible=true, value=error_value, type="percent", symmetric=true)
  (color !== nothing) && (eb.color = color)
  eb
end

function ErrorBar(error_value::Number, error_valueminus::Number; color::Union{String,Nothing} = nothing)
  eb = ErrorBar(visible=true, value=error_value, type="percent", symmetric=false, valueminus=error_valueminus)
  (color !== nothing) && (eb.color = color)
  eb
end

function Base.Dict(eb::ErrorBar)
  trace = Dict{Symbol, Any}()

  optionals!(trace, eb, [
    :array, :arrayminus, :color, :copy_ystyle, :symmetric, :thickness,
    :traceref, :tracerefminus, :type, :value, :valueminus, :visible, :width
  ])
end

function Stipple.render(eb::ErrorBar, fieldname::Union{Symbol,Nothing} = nothing)
  Dict(eb)
end

#===#
"""
    PlotAnnotation()

----------
# Examples
----------

```
julia>
```

-----------
# Properties
-----------
* `align::String` -Sets the horizontal alignment of the `text` within the box. Has an effect only if `text` spans two or more lines (i.e. `text` contains one or more <br> HTML tags) or if an explicit width is set to override the text width. Type: enumerated , one of ( `"left"` | `"center"` | `"right"` ) | Default: `"center"`
* `arrowcolor::String` -Sets the color of the annotation arrow.
* `arrowhead::Int` - Sets the end annotation arrow head style.  Type: integer between or equal to `0` and `8` | Default: `1`
* `arrowside::String` - Sets the annotation arrow head position. Type: flaglist string. Any combination of `"end"`, `"start"` joined with a `"+"` OR `"none"` | Default: `"end"`
* `arrowsize::Float64` - Sets the size of the end annotation arrow head, relative to `arrowwidth`. A value of 1 (default) gives a head about 3x as wide as the line. Type: number greater than or equal to `0.3` | Default: `1`
* `arrowwidth::Float64` - Sets the width (in px) of annotation arrow line. Type: number greater than or equal to `0.1`
* `ax::Union{String,Int,Float64}` - Sets the x component of the arrow tail about the arrow head. If `axref` is `pixel`, a positive (negative) component corresponds to an arrow pointing from right to left (left to right). If `axref` is not `pixel` and is exactly the same as `xref`, this is an absolute value on that axis, like `x`, specified in the same coordinates as `xref`. Type: number or categorical coordinate string
* `axref::String` - Indicates in what coordinates the tail of the annotation (ax,ay) is specified. If set to a ax axis id (e.g. "ax" or "ax2"), the `ax` position refers to a ax coordinate. If set to "paper", the `ax` position refers to the distance from the left of the plotting area in normalized coordinates where "0" ("1") corresponds to the left (right). If set to a ax axis ID followed by "domain" (separated by a space), the position behaves like for "paper", but refers to the distance in fractions of the domain length from the left of the domain of that axis: e.g., "ax2 domain" refers to the domain of the second ax axis and a ax position of 0.5 refers to the point between the left and the right of the domain of the second ax axis. In order for absolute positioning of the arrow to work, "axref" must be exactly the same as "xref", otherwise "axref" will revert to "pixel" (explained next). For relative positioning, "axref" can be set to "pixel", in which case the "ax" value is specified in pixels relative to "x". Absolute positioning is useful for trendline annotations which should continue to indicate the correct trend when zoomed. Relative positioning is useful for specifying the text offset for an annotated point. Type: enumerated , one of ( `"pixel"` | `"/^x([2-9]|[1-9][0-9]+)?( domain)?\$/"`) | Default: `"pixel"`
* `ay::Union{String,Int,Float64}` - Sets the y component of the arrow tail about the arrow head. If `ayref` is `pixel`, a positive (negative) component corresponds to an arrow pointing from bottom to top (top to bottom). If `ayref` is not `pixel` and is exactly the same as `yref`, this is an absolute value on that axis, like `y`, specified in the same coordinates as `yref`. Type: number or categorical coordinate string
* `ayref::String` - Indicates in what coordinates the tail of the annotation (ax,ay) is specified. If set to a ay axis id (e.g. "ay" or "ay2"), the `ay` position refers to a ay coordinate. If set to "paper", the `ay` position refers to the distance from the bottom of the plotting area in normalized coordinates where "0" ("1") corresponds to the bottom (top). If set to a ay axis ID followed by "domain" (separated by a space), the position behaves like for "paper", but refers to the distance in fractions of the domain length from the bottom of the domain of that axis: e.g., "ay2 domain" refers to the domain of the second ay axis and a ay position of 0.5 refers to the point between the bottom and the top of the domain of the second ay axis. In order for absolute positioning of the arrow to work, "ayref" must be exactly the same as "yref", otherwise "ayref" will revert to "pixel" (explained next). For relative positioning, "ayref" can be set to "pixel", in which case the "ay" value is specified in pixels relative to "y". Absolute positioning is useful for trendline annotations which should continue to indicate the correct trend when zoomed. Relative positioning is useful for specifying the text offset for an annotated point. Type: enumerated , one of ( `"pixel"` | `"/^x([2-9]|[1-9][0-9]+)?( domain)?\$/"`) | Default: `"pixel"`
* `bgcolor::String` -Sets the background color of the annotation. Default: `"rgba(0,0,0,0)"`
* `bordercolor::String` - Sets the color of the border enclosing the annotation `text`. Default: `"rgba(0,0,0,0)"`
* `borderpad::Int` - Sets the padding (in px) between the `text` and the enclosing border. Default: `1`
* `borderwidth::Int` - Sets the width (in px) of the border enclosing the annotation `text`. Type: number greater than or equal to 0 | Default: `1`
* `captureevents::Bool` - Determines whether the annotation text box captures mouse move and click events, or allows those events to pass through to data points in the plot that may be behind the annotation. By default `captureevents` is "false" unless `hovertext` is provided. If you use the event `plotly_clickannotation` without `hovertext` you must explicitly enable `captureevents`.
* `font::Font` - Sets the annotation text font.
* `height::Int` - Sets an explicit height for the text box. null (default) lets the text set the box height. Taller text will be clipped. Type: number greater than or equal to `1`
* `hoverlabel::Dict` -  object containing one or more of the keys listed: `bgcolor` `bordercolor` `font`
* `name::String` - When used in a template, named items are created in the output figure in addition to any items the figure already has in this array. You can modify these items in the output figure by making your own item with `templateitemname` matching this `name` alongside your modifications (including `visible: false` or `enabled: false` to hide it). Has no effect outside of a template.
* `opacity::Float64` - Sets the opacity of the annotation (text + arrow). Type: number between or equal to `0` and `1` | Default: `1`
* `showarrow::Bool` - Determines whether or not the annotation is drawn with an arrow. If "true", `text` is placed near the arrow's tail. If "false", `text` lines up with the `x` and `y` provided. Default: `true`
* `standoff::Int` - Sets a distance, in pixels, to move the end arrowhead away from the position it is pointing at, for example to point at the edge of a marker independent of zoom. Note that this shortens the arrow from the `ax` / `ay` vector, in contrast to `xshift` / `yshift` which moves everything by this amount.  Type: number greater than or equal to `0` | Default: `0`
* `startarrowhead::Int` -  Sets the start annotation arrow head style.  Type: integer between or equal to `0` and `8` | Default: `1`
* `startarrowsize::Int` - Sets the size of the start annotation arrow head, relative to `arrowwidth`. A value of 1 (default) gives a head about 3x as wide as the line.  Type: number greater than or equal to `0.3` | Default: `1`
* `startstandoff::Int` - Sets a distance, in pixels, to move the start arrowhead away from the position it is pointing at, for example to point at the edge of a marker independent of zoom. Note that this shortens the arrow from the `ax` / `ay` vector, in contrast to `xshift` / `yshift` which moves everything by this amount.  Type: number greater than or equal to `0` | Default: `0`
* `templateitemname::String` - Used to refer to a named item in this array in the template. Named items from the template will be created even without a matching item in the input figure, but you can modify one by making an item with `templateitemname` matching its `name`, alongside your modifications (including `visible: false` or `enabled: false` to hide it). If there is no template or no matching item, this item will be hidden unless you explicitly show it with `visible: true`.
* `text::String` - Sets the text associated with the annotation. Plotly uses a subset of HTML tags to do things like newline (<br>), bold (<b></b>), italics (<i></i>), hyperlinks (<a href='...'></a>). Tags <em>, <sup>, <sub> <span> are also supported. Type: string
* `textangle::Union{Int,Float64}` - Sets the angle at which the `text` is drawn with respect to the horizontal. Type: `angle` | Default: `0`
* `valign::String` - Sets the vertical alignment of the `text` within the box. Has an effect only if an explicit height is set to override the text height. Type: enumerated , one of ( `"top"` | `"middle"` | `"bottom"`) | Default: `"middle"`
* `visible::Bool` `visible` - Determines whether or not this annotation is visible. Type: boolean | Default: `true`
* `width::Int` - Sets an explicit width for the text box. null (default) lets the text set the box width. Wider text will be clipped. Type: number greater than or equal to `1`
* `x::Union{String,Int,Float64}` - Sets the annotation's x position. If the axis `type` is "log", then you must take the log of your desired range. If the axis `type` is "date", it should be date strings, like date data, though Date objects and unix milliseconds will be accepted and converted to strings. If the axis `type` is "category", it should be numbers, using the scale where each category is assigned a serial number from zero in the order it appears.
* `xanchor::String` - Sets the text box's horizontal position anchor This anchor binds the `x` position to the "left", "center" or "right" of the annotation. For example, if `x` is set to 1, `xref` to "paper" and `xanchor` to "right" then the right-most portion of the annotation lines up with the right-most edge of the plotting area. If "auto", the anchor is equivalent to "center" for data-referenced annotations or if there is an arrow, whereas for paper-referenced with no arrow, the anchor picked corresponds to the closest side. Type: enumerated , one of ( `"auto"` | `"left"` | `"center"` | `"right"`) | Default: `"auto"`
* `xref::Union{String,Int,Float64}` - Sets the annotation's x coordinate axis. If set to a x axis id (e.g. "x" or "x2"), the `x` position refers to a x coordinate. If set to "paper", the `x` position refers to the distance from the left of the plotting area in normalized coordinates where "0" ("1") corresponds to the left (right). If set to a x axis ID followed by "domain" (separated by a space), the position behaves like for "paper", but refers to the distance in fractions of the domain length from the left of the domain of that axis: e.g., "x2 domain" refers to the domain of the second x axis and a x position of 0.5 refers to the point between the left and the right of the domain of the second x axis.  Type: enumerated , one of ( `"paper"` | `"/^x([2-9]|[1-9][0-9]+)?( domain)?\$/"` )
* `xshift::Union{Int,Float64}` - Shifts the position of the whole annotation and arrow to the right (positive) or left (negative) by this many pixels. Default: `0`
* `y::Union{String,Int,Float64}` - Sets the annotation's y position. If the axis `type` is "log", then you must take the log of your desired range. If the axis `type` is "date", it should be date strings, like date data, though Date objects and unix milliseconds will be accepted and converted to strings. If the axis `type` is "category", it should be numbers, using the scale where each category is assigned a serial number from zero in the order it appears.
* `yanchor::Union{String}` - Sets the text box's vertical position anchor This anchor binds the `y` position to the "top", "middle" or "bottom" of the annotation. For example, if `y` is set to 1, `yref` to "paper" and `yanchor` to "top" then the top-most portion of the annotation lines up with the top-most edge of the plotting area. If "auto", the anchor is equivalent to "middle" for data-referenced annotations or if there is an arrow, whereas for paper-referenced with no arrow, the anchor picked corresponds to the closest side. Type: enumerated , one of ( `"auto"` | `"top"` | `"middle"` | `"bottom"`) | Default: `"auto"`
* `yref::Union{String,Int,Float64}` - Sets the annotation's y coordinate axis. If set to a y axis id (e.g. "y" or "y2"), the `y` position refers to a y coordinate. If set to "paper", the `y` position refers to the distance from the bottom of the plotting area in normalized coordinates where "0" ("1") corresponds to the bottom (top). If set to a y axis ID followed by "domain" (separated by a space), the position behaves like for "paper", but refers to the distance in fractions of the domain length from the bottom of the domain of that axis: e.g., "y2 domain" refers to the domain of the second y axis and a y position of 0.5 refers to the point between the bottom and the top of the domain of the second y axis. Type: enumerated , one of ( `"paper"` | `"/^x([2-9]|[1-9][0-9]+)?( domain)?\$/"` )
* `yshift::Union{Int,Float64}` - Shifts the position of the whole annotation and arrow up (positive) or down (negative) by this many pixels. Default: `0`
"""
Base.@kwdef mutable struct PlotAnnotation
  align::Union{String,Nothing} = nothing
  arrowcolor::Union{String,Nothing} = nothing
  arrowhead::Union{Int,Nothing} = nothing
  arrowside::Union{String,Nothing} = nothing
  arrowsize::Union{Float64,Nothing} = nothing
  arrowwidth::Union{Float64,Nothing} = nothing
  ax::Union{String,Int,Float64,Nothing} = nothing
  axref::Union{String,Nothing} = nothing
  ay::Union{String,Int,Float64,Nothing} = nothing
  ayref::Union{String,Nothing} = nothing
  bgcolor::Union{String,Nothing} = nothing
  bordercolor::Union{String,Nothing} = nothing
  borderpad::Union{Int,Nothing} = nothing
  borderwidth::Union{Int,Nothing} = nothing
  captureevents::Union{Bool,Nothing} = nothing
  # TODO: clicktoshow
  # TODO: xclick
  # TODO: yclick
  font::Union{Font,Nothing} = nothing
  height::Union{Float64,Int,Nothing} = nothing
  hoverlabel::Union{Dict,Nothing} = nothing
  name::Union{String,Nothing} = nothing
  opacity::Union{Float64,Nothing} = nothing
  showarrow::Union{Bool,Nothing} = nothing
  standoff::Union{Int,Nothing} = nothing
  startarrowhead::Union{Int,Nothing} = nothing
  startarrowsize::Union{Float64,Nothing} = nothing
  startstandoff::Union{Int,Nothing} = nothing
  templateitemname::Union{String,Nothing} = nothing
  text::Union{String,Nothing} = nothing
  textangle::Union{Float64,Int,Nothing} = nothing
  valign::Union{String,Nothing} = nothing
  visible::Union{Bool,Nothing} = nothing
  width::Union{Float64,Int,Nothing} = nothing
  x::Union{String,Int,Float64,Nothing} = nothing
  xanchor::Union{String,Nothing} = nothing
  xref::Union{String,Int,Float64,Nothing} = nothing
  xshift::Union{Int,Float64,Nothing} = nothing
  y::Union{String,Int,Float64,Nothing} = nothing
  yanchor::Union{String,Nothing} = nothing
  yref::Union{String,Int,Float64,Nothing} = nothing
  yshift::Union{Int,Float64,Nothing} = nothing
end

function Base.show(io::IO, an::PlotAnnotation)
  output = "Annotation: \n"
  for f in fieldnames(typeof(an))
    prop = getproperty(an, f)
    if prop !== nothing
      output *= "$f = $prop \n"
    end
  end

  print(io, output)
end

function Base.Dict(an::PlotAnnotation)
  trace = Dict{Symbol,Any}()

  if an.font !== nothing
    trace[:font] = Dict(
      :family => an.font.family,
      :size => an.font.size,
      :color => an.font.color
    )
  end

  if an.hoverlabel !== nothing
    trace[:hoverlabel] = an.hoverlabel
  end

  optionals!(trace, an, [:align, :arrowcolor, :arrowhead, :arrowside, :arrowsize, :arrowwidth,
         :ax, :axref, :ay, :ayref, :bgcolor, :bordercolor, :borderpad, :borderwidth, :captureevents,
         :height, :hoverlabel, :name, :opacity, :showarrow, :standoff, :startarrowhead, :startarrowsize,
         :startstandoff, :templateitemname, :text, :textangle, :valign, :visible, :width, :x, :xanchor,
          :xref, :xshift, :y, :yanchor, :yref, :yshift])
end

function Stipple.render(anv::Vector{PlotAnnotation}, fieldname::Union{Symbol,Nothing} = nothing)
  [Dict(an) for an in anv]
end

#===#
"""
    PlotAnnotation()

----------
# Examples
----------

```
julia>
```

-----------
# Properties
-----------
* `anchor::String` - If set to an opposite-letter axis id (e.g. `x2`, `y`), this axis is bound to the corresponding opposite-letter axis. If set to "free", this axis' position is determined by `position`. Type: enumerated , one of ( `"free"` | `"/^x([2-9]|[1-9][0-9]+)?( domain)?\$/"` |` "/^y([2-9]|[1-9][0-9]+)?( domain)?\$/"` )
* `automargin::Bool` - Determines whether this axis' margin is computed automatically. Type: boolean
* `autorange::Bool` - Determines whether or not the range of this axis is computed in relation to the input data. See `rangemode` for more info. If `range` is provided, then `autorange` is set to "false". Type: enumerated , one of ( `true` | `false` | `"reversed"` ) | Default: `true`
* `autotypenumbers::String` - Using "strict" a numeric string in trace data is not converted to a number. Using "convert types" a numeric string in trace data may be treated as a number during automatic axis `type` detection. Defaults to layout.autotypenumbers. Type: enumerated , one of ( `"strict"` | `"convert types"` ) | Default: `"convert types"`
* `calendar::String` - Sets the calendar system to use for `range` and `tick0` if this is a date axis. This does not set the calendar for interpreting data on this axis, that's specified in the trace or via the global `layout.calendar`. Type: enumerated , one of ( `"gregorian"` | `"chinese"` | `"coptic"` | `"discworld"` | `"ethiopian"` | `"hebrew"` | `"islamic"` | `"julian"` | `"mayan"` | `"nanakshahi"` | `"nepali"` | `"persian"` | `"jalali"` | `"taiwan"` | `"thai"` | `"ummalqura"` ) | Default: `"gregorian"`
* `categoryarray::Vector{Float64}` - Sets the order in which categories on this axis appear. Only has an effect if `categoryorder` is set to "array". Used with `categoryorder`. Type: Vector 
* `categoryorder::String` - Specifies the ordering logic for the case of categorical variables. By default, plotly uses "trace", which specifies the order that is present in the data supplied. Set `categoryorder` to "category ascending" or "category descending" if order should be determined by the alphanumerical order of the category names. Set `categoryorder` to "array" to derive the ordering from the attribute `categoryarray`. If a category is not found in the `categoryarray` array, the sorting behavior for that attribute will be identical to the "trace" mode. The unspecified categories will follow the categories in `categoryarray`. Set `categoryorder` to "total ascending" or "total descending" if order should be determined by the numerical order of the values. Similarly, the order can be determined by the min, max, sum, mean or median of all the values. Type: enumerated , one of ( `"trace"` | `"category ascending"` | `"category descending"` | `"array"` | `"total ascending"` | `"total descending"` ) | Default: `"trace"`
* `constrain::String` - If this axis needs to be compressed (either due to its own `scaleanchor` and `scaleratio` or those of the other axis), determines how that happens: by increasing the "range", or by decreasing the "domain". Default is "domain" for axes containing image traces, "range" otherwise. Type: enumerated , one of ( `"domain"` | `"range"` )
* `constraintoward::String` - If this axis needs to be compressed (either due to its own `scaleanchor` and `scaleratio` or those of the other axis), determines which direction we push the originally specified plot area. Options are "left", "center" (default), and "right" for x axes, and "top", "middle" (default), and "bottom" for y axes. Type: enumerated , one of ( `"left"` | `"center"` | `"right"` | `"top"` | `"middle"` | `"bottom"` )
* `dividercolor::String` - Sets the color of the dividers Only has an effect on "multicategory" axes. Type: color | Default: `"#444"`
* `dividerwidth::Float` - Sets the width (in px) of the dividers Only has an effect on "multicategory" axes. Type: float | Default: `1`
* `domain::Vector{Float64}` - Sets the domain of this axis (in plot fraction). Type: Vector
* `dtick::Union{Float64,Int,String}` - Sets the step in-between ticks on this axis. Use with `tick0`. Must be a positive number, or special strings available to "log" and "date" axes. If the axis `type` is "log", then ticks are set every 10^(n"dtick) where n is the tick number. For example, to set a tick mark at 1, 10, 100, 1000, ... set dtick to 1. To set tick marks at 1, 100, 10000, ... set dtick to 2. To set tick marks at 1, 5, 25, 125, 625, 3125, ... set dtick to log_10(5), or 0.69897000433. "log" has several special values; "L<f>", where `f` is a positive number, gives ticks linearly spaced in value (but not position). For example `tick0` = 0.1, `dtick` = "L0.5" will put ticks at 0.1, 0.6, 1.1, 1.6 etc. To show powers of 10 plus small digits between, use "D1" (all digits) or "D2" (only 2 and 5). `tick0` is ignored for "D1" and "D2". If the axis `type` is "date", then you must convert the time to milliseconds. For example, to set the interval between ticks to one day, set `dtick` to 86400000.0. "date" also has special values "M<n>" gives ticks spaced by a number of months. `n` must be a positive integer. To set ticks on the 15th of every third month, set `tick0` to "2000-01-15" and `dtick` to "M3". To set ticks every 4 years, set `dtick` to "M48"
* `fixedrange::Bool` - Determines whether or not this axis is zoom-able. If true, then zoom is disabled.
* `font::Font` - Check Font structure for signature.
* `gridcolor::String` - Sets the color of the grid lines. Type: color | Default: `"#eee"`
* `gridwidth::Int` - Sets the width (in px) of the grid lines. Type: float | Default: `1`
* `hoverformat::String` - Sets the hover text formatting rule using d3 formatting mini-languages which are very similar to those in Python. For numbers, see: https://github.com/d3/d3-format/tree/v1.4.5#d3-format. And for dates see: https://github.com/d3/d3-time-format/tree/v2.2.3#locale_format. We add two items to d3's date formatter: "%h" for half of the year as a decimal number as well as "%{n}f" for fractional seconds with n digits. For example, "2016-10-13 09:15:23.456" with tickformat "%H~%M~%S.%2f" would display "09~15~23.46". Default: `""`
* `layer::String` - Sets the layer on which this axis is displayed. If "above traces", this axis is displayed above all the subplot's traces If "below traces", this axis is displayed below all the subplot's traces, but above the grid lines. Useful when used together with scatter-like traces with `cliponaxis` set to "false" to show markers and/or text nodes above this axis. Type: enumerated , one of ( `"above traces"` | `"below traces"` ) | Default: `"above traces"`
* `linecolor::String` - Sets the axis line color. Type: color | Default: `"#444"`
* `linewidth::Int` - Sets the width (in px) of the axis line. Type: float | Default: `1`
* `minexponent::Int` - Hide SI prefix for 10^n if |n| is below this number. This only has an effect when `tickformat` is "SI" or "B". Type: number greater than or equal to `0` | Default: `3`
* `mirror::Union{Bool,String}` - Determines if the axis lines or/and ticks are mirrored to the opposite side of the plotting area. If "true", the axis lines are mirrored. If "ticks", the axis lines and ticks are mirrored. If "false", mirroring is disable. If "all", axis lines are mirrored on all shared-axes subplots. If "allticks", axis lines and ticks are mirrored on all shared-axes subplots. Type: `enumerated , one of ( `true` | `"ticks"` | `false` | `"all"` | `"allticks"` )`
* `nticks::Int` - Specifies the maximum number of ticks for the particular axis. The actual number of ticks will be chosen automatically to be less than or equal to `nticks`. Has an effect only if `tickmode` is set to "auto". Type: number greater than or equal to `0` | Default: `0`
* `overlaying::String` - If set a same-letter axis id, this axis is overlaid on top of the corresponding same-letter axis, with traces and axes visible for both axes. If "false", this axis does not overlay any same-letter axes. In this case, for axes with overlapping domains only the highest-numbered axis will be visible. Type: enumerated , one of ( `"free"` | `"/^x([2-9]|[1-9][0-9]+)?( domain)?\$/"` | `"/^y([2-9]|[1-9][0-9]+)?( domain)?\$/"` )
* `position::Float64` - Sets the position of this axis in the plotting space (in normalized coordinates). Only has an effect if `anchor` is set to "free". Type: number between or equal to `0` and `1` | Default: `0`
* `range::Union{Vector{Int},Vector{Float64}}` - Sets the range of this axis. If the axis `type` is "log", then you must take the log of your desired range (e.g. to set the range from 1 to 100, set the range from 0 to 2). If the axis `type` is "date", it should be date strings, like date data, though Date objects and unix milliseconds will be accepted and converted to strings. If the axis `type` is "category", it should be numbers, using the scale where each category is assigned a serial number from zero in the order it appears.
* `rangemode::String` - If "normal", the range is computed in relation to the extrema of the input data. If "tozero"`, the range extends to 0, regardless of the input data If "nonnegative", the range is non-negative, regardless of the input data. Applies only to linear axes. Type: enumerated , one of ( `"normal"` | `"tozero"` | `"nonnegative"` ) | Default: `"normal"`
* `scaleanchor::String` - If set to another axis id (e.g. `x2`, `y`), the range of this axis changes together with the range of the corresponding axis such that the scale of pixels per unit is in a constant ratio. Both axes are still zoomable, but when you zoom one, the other will zoom the same amount, keeping a fixed midpoint. `constrain` and `constraintoward` determine how we enforce the constraint. You can chain these, ie `yaxis: {scaleanchor: "x"}, xaxis2: {scaleanchor: "y"}` but you can only link axes of the same `type`. The linked axis can have the opposite letter (to constrain the aspect ratio) or the same letter (to match scales across subplots). Loops (`yaxis: {scaleanchor: "x"}, xaxis: {scaleanchor: "y"}` or longer) are redundant and the last constraint encountered will be ignored to avoid possible inconsistent constraints via `scaleratio`. Note that setting axes simultaneously in both a `scaleanchor` and a `matches` constraint is currently forbidden. Type: enumerated , one of ( `"/^x([2-9]|[1-9][0-9]+)?( domain)?\$/"` | `"/^y([2-9]|[1-9][0-9]+)?( domain)?\$/"` )
* `scaleratio::Int` -  If this axis is linked to another by `scaleanchor`, this determines the pixel to unit scale ratio. For example, if this value is 10, then every unit on this axis spans 10 times the number of pixels as a unit on the linked axis. Use this for example to create an elevation profile where the vertical scale is exaggerated a fixed amount with respect to the horizontal. Type: number greater than or equal to `0` | Default: `1`
* `showdividers::Bool` - Determines whether or not a dividers are drawn between the category levels of this axis. Only has an effect on "multicategory" axes. Type: boolean | Default: `true`
* `showexponent::String` - If "all", all exponents are shown besides their significands. If "first", only the exponent of the first tick is shown. If "last", only the exponent of the last tick is shown. If "none", no exponents appear. Type: enumerated , one of ( `"all"` | `"first"` | `"last"` | `"none"` ) | Default: `"all"`
* `showgrid::Bool` - Determines whether or not grid lines are drawn. If True, the grid lines are drawn at every tick mark. Type: boolean | Default: `true`
* `showline::Bool` - Determines whether or not a line bounding this axis is drawn. Type: boolean
* `showspikes::Bool` - Determines whether or not spikes (aka droplines) are drawn for this axis. Note: This only takes affect when hovermode = closest. Type: boolean
* `showticklabels::Bool` - Determines whether or not the tick labels are drawn.
* `side::String` - Determines whether a x (y) axis is positioned at the "bottom" ("left") or "top" ("right") of the plotting area. Type: enumerated , one of ( `"top"` | `"bottom"` | `"left"` | `"right"` ) | Default: `"bottom"`
* `spikecolor::String` - Sets the spike color. If undefined, will use the series color
* `spikedash::String` - Sets the dash style of lines. Set to a dash type string ("solid", "dot", "dash", "longdash", "dashdot", or "longdashdot") or a dash length list in px (eg "5px,10px,2px,2px").
* `spikemode::String` - Determines the drawing mode for the spike line If "toaxis", the line is drawn from the data point to the axis the  series is plotted on. If "across", the line is drawn across the entire plot area, and supercedes "toaxis". If "marker", then a marker dot is drawn on the axis the series is plotted on. Type: Any combination of `"toaxis"`, `"across"`, `"marker"` joined with a `"+"` | Examples. `"toaxis"` | `"across"` | `"marker"` | `"toaxis+across"` | `"toaxis+marker"` | `"across+marker"` | `"toaxis+across+marker"` | Default: `"toaxis"`
* `spikesnap::String` - Determines whether spikelines are stuck to the cursor or to the closest datapoints. Type: enumerated , one of ( `"data"` | `"cursor"` | `"hovered data"`) | Default: `"hovered data"`
* `spikethickness::Int` - Sets the width (in px) of the zero line. Default: 3
* `tick0::Union{Float64,Int,String}` - Sets the placement of the first tick on this axis. Use with `dtick`. If the axis `type` is "log", then you must take the log of your starting tick (e.g. to set the starting tick to 100, set the `tick0` to 2) except when `dtick`="L<f>" (see `dtick` for more info). If the axis `type` is "date", it should be a date string, like date data. If the axis `type` is "category", it should be a number, using the scale where each category is assigned a serial number from zero in the order it appears.
* `tickangle::Union{String,Int,Float64}` - Sets the angle of the tick labels with respect to the horizontal. For example, a `tickangle` of -90 draws the tick labels vertically. Default: `"auto"`
* `tickcolor::String` - Sets the tick color. Default: `"#444"`
* `tickformat::String` - Sets the tick label formatting rule using d3 formatting mini-languages which are very similar to those in Python. For numbers, see: https://github.com/d3/d3-format/tree/v1.4.5#d3-format. And for dates see: https://github.com/d3/d3-time-format/tree/v2.2.3#locale_format. We add two items to d3's date formatter: "%h" for half of the year as a decimal number as well as "%{n}f" for fractional seconds with n digits. For example, "2016-10-13 09:15:23.456" with tickformat "%H~%M~%S.%2f" would display "09~15~23.46". Default: `""`
* `ticklabelmode::String` - Determines where tick labels are drawn with respect to their corresponding ticks and grid lines. Only has an effect for axes of `type` "date" When set to "period", tick labels are drawn in the middle of the period between ticks. Type: enumerated , one of ( `"instant"` | `"period"` ) | Default: `"instant"`
* `ticklabeloverflow::String` - Determines how we handle tick labels that would overflow either the graph div or the domain of the axis. The default value for inside tick labels is "hide past domain". Otherwise on "category" and "multicategory" axes the default is "allow". In other cases the default is "hide past div". Type: enumerated , one of ( `"allow"` |` "hide past div"` | `"hide past domain"` )
* `ticklabelposition::String` - Determines where tick labels are drawn with respect to the axis Please note that top or bottom has no effect on x axes or when `ticklabelmode` is set to "period". Similarly left or right has no effect on y axes or when `ticklabelmode` is set to "period". Has no effect on "multicategory" axes or when `tickson` is set to "boundaries". When used on axes linked by `matches` or `scaleanchor`, no extra padding for inside labels would be added by autorange, so that the scales could match. Type: enumerated , one of ( `"top"` | `"bottom"` | `"left"` | `"right"` | `"outsideleft"` | `"insideleft"` ) | Default: `"outside"`
* `ticklen::Int` - Sets the tick length (in px). Default: `5`
* `tickmode::String` - Sets the tick mode for this axis. If "auto", the number of ticks is set via `nticks`. If "linear", the placement of the ticks is determined by a starting position `tick0` and a tick step `dtick` ("linear" is the default value if `tick0` and `dtick` are provided). If "array", the placement of the ticks is set via `tickvals` and the tick text is `ticktext`. ("array" is the default value if `tickvals` is provided). Type: enumerated , one of ( `"auto"` | `"linear"` | `"array"` )
* `tickprefix::String` -  Sets a tick label prefix. Default: `""`
* `ticks::String` - Determines whether ticks are drawn or not. If "", this axis' ticks are not drawn. If "outside" ("inside"), this axis' are drawn outside (inside) the axis lines.
* `tickson::String` - Determines where ticks and grid lines are drawn with respect to their corresponding tick labels. Only has an effect for axes of `type` "category" or "multicategory". When set to "boundaries", ticks and grid lines are drawn half a category to the left/bottom of labels. Type: enumerated , one of (`"labels"` | `"boundaries"` ) | Default: `"labels"`
* `ticksuffix::String` - Sets a tick label suffix. Default: `""`
* `ticktext::Vector{String}` - Sets the text displayed at the ticks position via `tickvals`. Only has an effect if `tickmode` is set to "array". Used with `tickvals`.
* `tickvals::Union{Vector{Float64},Vector{Int}}` - Sets the values at which ticks on this axis appear. Only has an effect if `tickmode` is set to "array". Used with `ticktext`.
* `tickwidth::Int` - Sets the tick width (in px). Type: number greater than or equal to `0` | Default: `1`
* `title::String` - Sets the title of this axis.
* `type::String` - Sets the axis type. By default, plotly attempts to determined the axis type by looking into the data of the traces that referenced the axis in question. Type: enumerated , one of ( `"-"` | `"linear"` | `"log"` | `"date"` | `"category"` | `"multicategory"` ) |  Default: `"-"`
* `visible::Bool` - A single toggle to hide the axis while preserving interaction like dragging. Default is true when a cheater plot is present on the axis, otherwise false
* `zeroline::Bool` - Determines whether or not a line is drawn at along the 0 value of this axis. If "true", the zero line is drawn on top of the grid lines.
* `zerolinecolor::String` - Sets the line color of the zero line. Default: `#444`
* `zerolinewidth::Int` - Sets the width (in px) of the zero line. Default: `1`

#### Important

* `xy::String` - Sets a reference to the x or y axis. If "x", the `x` axis will be matched. If "y", the `y` axis will be matched.
* `index::Int` - 1 # 1, 2, 3 etc. for subplots
* `title_text::String` - Sets the text of the title of this axis.
* `title_font::Font` - Sets the title font.
* `title_standoff:Int` - Sets the standoff distance between the axis title and the axis labels, in pixels.
"""
Base.@kwdef mutable struct PlotLayoutAxis
  anchor::Union{String,Nothing} = nothing
  automargin::Union{Bool,Nothing} = nothing
  autorange::Union{Bool,String,Nothing} = nothing
  autotypenumbers::Union{String,Nothing} = nothing
  calendar::Union{String,Nothing} = nothing
  categoryarray::Union{Vector{Float64},Nothing} = nothing
  categoryorder::Union{String,Nothing} = nothing
  constrain::Union{String,Nothing} = nothing
  constraintoward::Union{String,Nothing} = nothing
  dividercolor::Union{String,Nothing} = nothing
  dividerwidth::Union{Int,Nothing} = nothing
  domain::Union{Vector{Float64},Nothing} = nothing
  dtick::Union{Float64,Int,String,Nothing} = nothing
  fixedrange::Union{Bool,Nothing} = nothing
  font::Union{Font,Nothing} = nothing
  gridcolor::Union{String,Nothing} = nothing
  gridwidth::Union{Int,Nothing} = nothing
  hoverformat::Union{String,Nothing} = nothing
  layer::Union{String,Nothing} = nothing
  linecolor::Union{String,Nothing} = nothing
  linewidth::Union{Int,Nothing} = nothing
  minexponent::Union{Int,Nothing} = nothing
  mirror::Union{Bool,String,Nothing} = nothing
  nticks::Union{Int,Nothing} = nothing
  overlaying::Union{String,Nothing} = nothing
  position::Union{Float64,Nothing} = nothing
  range::Union{Vector{Int},Vector{Float64},Nothing} = nothing
  rangemode::Union{String,Nothing} = nothing
  scaleanchor::Union{String,Nothing} = nothing
  scaleratio::Union{Int,Nothing} = nothing
  showdividers::Union{Bool,Nothing} = nothing
  showexponent::Union{String,Nothing} = nothing
  showgrid::Union{Bool,Nothing} = nothing
  showline::Union{Bool,Nothing} = nothing
  showspikes::Union{Bool,Nothing} = nothing
  showticklabels::Union{Bool,Nothing} = nothing
  side::Union{String,Nothing} = nothing
  spikecolor::Union{String,Nothing} = nothing
  spikedash::Union{String,Nothing} = nothing
  spikemode::Union{String,Nothing} = nothing
  spikesnap::Union{String,Nothing} = nothing
  spikethickness::Union{Int,Nothing} = nothing
  tick0::Union{Float64,Int,String,Nothing} = nothing
  tickangle::Union{String,Int,Float64,Nothing} = nothing
  tickcolor::Union{String,Nothing} = nothing
  tickfont::Union{Font,Nothing} = nothing
  tickformat::Union{String,Nothing} = nothing
  ticklabelmode::Union{String,Nothing} = nothing
  ticklabelposition::Union{String,Nothing} = nothing
  ticklen::Union{Int,Nothing} = nothing
  tickmode::Union{String,Nothing} = nothing
  tickprefix::Union{String,Nothing} = nothing
  ticks::Union{String,Nothing} = nothing
  tickson::Union{String,Nothing} = nothing
  ticksuffix::Union{String,Nothing} = nothing
  ticktext::Union{Vector{String},Nothing} = nothing
  tickvals::Union{Vector{Float64},Vector{Int},Nothing} = nothing
  tickwidth::Union{Int,Nothing} = nothing
  title::Union{String,Nothing} = nothing # "axis title"
  type::Union{String,Nothing} = nothing
  visible::Union{Bool,Nothing} = nothing
  zeroline::Union{Bool,Nothing} = nothing
  zerolinecolor::Union{String,Nothing} = nothing
  zerolinewidth::Union{Int,Nothing} = nothing
  # needs special treatment
  xy::String = "x" # "x" or "y"
  index::Int = 1 # 1, 2, 3 etc. for subplots
  title_text::Union{String,Nothing} = nothing
  title_font::Union{Font,Nothing} = nothing
  title_standoff::Union{Int,Nothing} = nothing
end

function Base.show(io::IO, la::PlotLayoutAxis)
  output = "Layout Axis: \n"
  for f in fieldnames(typeof(la))
    prop = getproperty(la, f)
    if prop !== nothing
      output *= "$f = $prop \n"
    end
  end

  print(io, output)
end

function Base.Dict(la::PlotLayoutAxis)
  trace = Dict{Symbol,Any}()

  if la.title_text !== nothing
    d = Dict{Symbol,Any}(:text => la.title_text)
    (la.title_font !== nothing) && (d[:font] = la.title_font)
    (la.title_standoff !== nothing) && (d[:standoff] = la.title_standoff)
    trace[:title] = d
  end

  d = optionals!(trace, la, [
    :anchor, :automargin, :autorange, :autotypenumbers, :calendar, :categoryarray,
    :categoryorder, :constrain, :constraintoward, :dividercolor, :dividerwidth, :domain, :dtick,
    :fixedrange, :font, :gridcolor, :gridwidth, :hoverformat, :layer, :linecolor, :linewidth,
    :minexponent, :mirror, :nticks, :overlaying, :position, :range, :rangemode, :scaleanchor,
    :scaleratio, :showdividers, :showexponent, :showgrid, :showline, :showspikes, :showticklabels,
    :side, :spikecolor, :spikedash, :spikemode, :spikesnap, :spikethickness, :tick0, :tickangle,
    :tickcolor, :tickfont, :tickformat, :ticklabelmode, :ticklabelposition, :ticklen, :tickmode,
    :tickprefix, :ticks, :tickson, :ticksuffix, :ticktext, :tickvals, :tickwidth, :title, :type,
    :visible, :zeroline, :zerolinecolor, :zerolinewidth])

  k = Symbol(la.xy * "axis" * ((la.index > 1) ? "$(la.index)" : ""))
  Dict(k => d)
end

function Stipple.render(la::PlotLayoutAxis, fieldname::Union{Symbol,Nothing} = nothing)
  [Dict(la)]
end

function Stipple.render(lav::Vector{PlotLayoutAxis}, fieldname::Union{Symbol,Nothing} = nothing)
  [Dict(la) for la in lav]
end

#===#

Base.@kwdef mutable struct PlotLayoutTitle
  text::Union{String,Nothing} = nothing # ""
  font::Union{Font,Nothing} = nothing # Font()
  xref::Union{String,Nothing} = nothing # LAYOUT_TITLE_REF_CONTAINER
  yref::Union{String,Nothing} = nothing # LAYOUT_TITLE_REF_CONTAINER
  x::Union{Float64,String,Nothing} = nothing # 0.5
  y::Union{Float64,String,Nothing} = nothing # LAYOUT_AUTO
  xanchor::Union{String,Nothing} = nothing # LAYOUT_AUTO
  yanchor::Union{String,Nothing} = nothing # LAYOUT_AUTO
  pad_t::Union{Int,Nothing} = nothing # 0
  pad_r::Union{Int,Nothing} = nothing # 0
  pad_b::Union{Int,Nothing} = nothing # 0
  pad_l::Union{Int,Nothing} = nothing # 0
end

function Base.show(io::IO, plt::PlotLayoutTitle)
  output = "Layout Title: \n"
  for f in fieldnames(typeof(plt))
    prop = getproperty(plt, f)
    if prop !== nothing
      output *= "$f = $prop \n"
    end
  end

  print(io, output)
end

function Base.Dict(plt::PlotLayoutTitle)
  trace = Dict{Symbol, Any}()

  d = Dict{Symbol, Any}()
  (plt.pad_t !== nothing) && (d[:t] = plt.pad_t)
  (plt.pad_r !== nothing) && (d[:r] = plt.pad_r)
  (plt.pad_b !== nothing) && (d[:b] = plt.pad_b)
  (plt.pad_l !== nothing) && (d[:l] = plt.pad_l)
  (length(d) > 0) && (trace[:pad] = d)

  optionals!(trace, plt, [:text, :font, :xref, :yref, :x, :y, :xanchor, :yanchor])
end

function Stipple.render(plt::PlotLayoutTitle, fieldname::Union{Symbol,Nothing} = nothing)
  Dict(plt)
end

#===#
"""
    PlotLayoutLegend()

----------
# Examples
----------

```
julia>
```

-----------
# Properties
-----------
* `bgcolor::String` -  Sets the legend background color. Defaults to `layout.paper_bgcolor`. Type: `color`
* `bordercolor::String` - Sets the color of the border enclosing the legend. Type: `color` | Default: `"#444"`
* `borderwidth::Int` - Sets the width (in px) of the border enclosing the legend. Type: `int` | Default: `0`
* `font::Font` - Sets the font used to text the legend items. Type: `Font` | Default: `Font()`
* `itemclick::Union{String,Bool}` - Determines the behavior on legend item click. "toggle" toggles the visibility of the item clicked on the graph. "toggleothers" makes the clicked item the sole visible item on the graph. "false" disables legend item click interactions.  Type: enumerated , one of ( `"toggle"` | `"toggleothers"` | `false` ) | Default: `"toggle"`
* `itemdoubleclick::Union{String,Bool}` - Determines the behavior on legend item double-click. "toggle" toggles the visibility of the item clicked on the graph. "toggleothers" makes the clicked item the sole visible item on the graph. "false" disables legend item double-click interactions. Type: enumerated , one of ( `"toggle"` | `"toggleothers"` | `false` ) | Default: `"toggleothers"`
* `itemsizing::String` - Determines if the legend items symbols scale with their corresponding "trace" attributes or remain "constant" independent of the symbol size on the graph.  Type: enumerated , one of ( `"trace"` | `"constant"` ) | Default: `"trace"`
* `itemwidth::Int` - Sets the width (in px) of the legend item symbols (the part other than the title.text). Type: `int` | Default: `30`
* `orientation::String` - Sets the orientation of the legend.  Type: enumerated , one of ( `"v"` | `"h"` ) | Default: `"v"`
* `title_text::String` - Sets the text of the legend's title. Type: `String`
* `title_font::Font` - Sets the font used for the legend's title. Type: `Font`
* `title_side::String` - Sets the side of the legend.
* `tracegroupgap::Int` - Sets the amount of vertical space (in px) between legend groups. Type: number greater than or equal to `0` | Default: `10`
* `traceorder::String` - Determines the order at which the legend items are displayed. If "normal", the items are displayed top-to-bottom in the same order as the input data. If "reversed", the items are displayed in the opposite order as "normal". If "grouped", the items are displayed in groups (when a trace `legendgroup` is provided). if "grouped+reversed", the items are displayed in the opposite order as "grouped". Type: flaglist string. Any combination of `"reversed"`, `"grouped"` joined with a `"+"` OR `"normal"`. | Examples: Examples: `"reversed"`, `"grouped"`, `"reversed+grouped"`, `"normal"`
* `valign::String` - Sets the vertical alignment of the symbols with respect to their associated text. Type: enumerated , one of ( `"top"` | `"middle"` | `"bottom"` ) | Default: `"middle"`
* `x::Union{Int,Float64}` - Sets the x position (in normalized coordinates) of the legend. Defaults to "1.02" for vertical legends and defaults to "0" for horizontal legends.  Type: number between or equal to `-2` and `3`
* `xanchor::String` - Sets the legend's horizontal position anchor. This anchor binds the `x` position to the "left", "center" or "right" of the legend. Value "auto" anchors legends to the right for `x` values greater than or equal to 2/3, anchors legends to the left for `x` values less than or equal to 1/3 and anchors legends with respect to their center otherwise. Type: enumerated , one of ( `"left"` | `"center"` | `"right"` | `"auto"` ) | Default: `"left"`
* `y::Union{Int,Float64}` - Sets the y position (in normalized coordinates) of the legend. Defaults to "1" for vertical legends, defaults to "-0.1" for horizontal legends on graphs w/o range sliders and defaults to "1.1" for horizontal legends on graph with one or multiple range sliders. Type: number between or equal to `-2` and `3`
* `yanchor::String` - Sets the legend's vertical position anchor This anchor binds the `y` position to the "top", "middle" or "bottom" of the legend. Value "auto" anchors legends at their bottom for `y` values less than or equal to 1/3, anchors legends to at their top for `y` values greater than or equal to 2/3 and anchors legends with respect to their middle otherwise. Type: enumerated , one of ( `"top"` | `"middle"` | `"bottom"` | `"auto"` )
"""

Base.@kwdef mutable struct PlotLayoutLegend
  bgcolor::Union{String,Nothing} = nothing
  bordercolor::Union{String,Nothing} = nothing # "#444"
  borderwidth::Union{Int,Nothing} = nothing # 0
  font::Union{Font,Nothing} = nothing # Font()
  itemclick::Union{String,Bool,Nothing} = nothing # LAYOUT_CLICK_TOGGLE
  itemdoubleclick::Union{String,Bool,Nothing} = nothing #  LAYOUT_CLICK_TOGGLEOTHERS
  itemsizing::Union{String,Nothing} = nothing # LAYOUT_ITEMSIZING_TRACE
  itemwidth::Union{Int,Nothing} = nothing # 30
  orientation::Union{String,Nothing} = nothing # LAYOUT_ORIENTATION_VERTICAL
  title_text::Union{String,Nothing} = nothing # ""
  title_font::Union{Font,Nothing} = nothing # Font()
  title_side::Union{String,Nothing} = nothing # LAYOUT_LEFT
  tracegroupgap::Union{Int,Nothing} = nothing # 10
  traceorder::Union{String,Nothing} = nothing # "normal"
  valign::Union{String,Nothing} = nothing # LAYOUT_MIDDLE
  x::Union{Int,Float64,Nothing} = nothing # 1.02
  xanchor::Union{String,Nothing} = nothing # LAYOUT_LEFT
  y::Union{Int,Float64,Nothing} = nothing # 1
  yanchor::Union{String,Nothing} = nothing # LAYOUT_AUTO
  # TODO: uirevision::Union{Int,String} = ""
end

function Base.show(io::IO, pll::PlotLayoutLegend)
  output = "Layout Legend: \n"
  for f in fieldnames(typeof(pll))
    prop = getproperty(pll, f)
    if prop !== nothing
      output *= "$f = $prop \n"
    end
  end

  print(io, output)
end

function Base.Dict(pll::PlotLayoutLegend)
  trace = Dict{Symbol, Any}()

  d = Dict{Symbol, Any}()
  (pll.title_text !== nothing) && (d[:text] = pll.title_text)
  (pll.title_font !== nothing) && (d[:font] = pll.title_font)
  (pll.title_side !== nothing) && (d[:side] = pll.title_side)
  (length(d) > 0) && (trace[:title] = d)

  optionals!(trace, pll, [
    :bgcolor, :bordercolor, :borderwidth, :font, :orientation, :tracegroupgap, :traceorder,
    :itemsizing, :itemwidth, :itemclick, :itemdoubleclick, :x, :xanchor, :y, :yanchor, :valign])
end

function Stipple.render(pll::PlotLayoutLegend, fieldname::Union{Symbol,Nothing} = nothing)
  Dict(pll)
end

#===#
"""
    PlotLayoutGrid()

----------
# Examples
----------

```
julia>
```

-----------
# Properties
-----------
* `columns::String` - The number of columns in the grid. If you provide a 2D `subplots` array, the length of its longest row is used as the default. If you give an `xaxes` array, its length is used as the default. But it's also possible to have a different length, if you want to leave a row at the end for non-cartesian subplots. Type: integer greater than or equal to `1`
* `domain_x::Vector{Float64}` - Sets the horizontal domain of this grid subplot (in plot fraction). The first and last cells end exactly at the domain edges, with no grout around the edges. Default: `[0, 1]`
* `domain_y::Vector{Float64}` - Sets the vertical domain of this grid subplot (in plot fraction). The first and last cells end exactly at the domain edges, with no grout around the edges. Default: `[0, 1]`
* `pattern::String` - If no `subplots`, `xaxes`, or `yaxes` are given but we do have `rows` and `columns`, we can generate defaults using consecutive axis IDs, in two ways: "coupled" gives one x axis per column and one y axis per row. "independent" uses a new xy pair for each cell, left-to-right across each row then iterating rows according to `roworder`. Type: one of `"coupled"` or `"independent"` | Default. `"coupled"`
* `roworder::String` - Is the first row the top or the bottom? Note that columns are always enumerated from left to right. enumerated , one of ( `"top to bottom"` | `"bottom to top"` ) | Default: `"top to bottom"`
* `rows::Int` - The number of rows in the grid. If you provide a 2D `subplots` array or a `yaxes` array, its length is used as the default. But it's also possible to have a different length, if you want to leave a row at the end for non-cartesian subplots. Type: integer greater than or equal to `1`
* `subplots::Matrix{String}` - Used for freeform grids, where some axes may be shared across subplots but others are not. Each entry should be a cartesian subplot id, like "xy" or "x3y2", or "" to leave that cell empty. You may reuse x axes within the same column, and y axes within the same row. Non-cartesian subplots and traces that support `domain` can place themselves in this grid separately using the `gridcell` attribute.
* `xaxes::Vector{String}` - Used with `yaxes` when the x and y axes are shared across columns and rows. Each entry should be an x axis id like "x", "x2", etc., or "" to not put an x axis in that column. Entries other than "" must be unique. Ignored if `subplots` is present. If missing but `yaxes` is present, will generate consecutive IDs.
* `xgap::Float64` - Horizontal space between grid cells, expressed as a fraction of the total width available to one cell. Defaults to 0.1 for coupled-axes grids and 0.2 for independent grids.  Type: number between or equal to `0` and `1`
* `xside::String` - Sets where the x axis labels and titles go. "bottom" means the very bottom of the grid. "bottom plot" is the lowest plot that each x axis is used in. "top" and "top plot" are similar.  Type: enumerated , one of ( `"bottom"` | `"bottom plot"` | `"top plot"` | `"top"` )  | Default: `"bottom plot"`
* `yaxes::Vector{String}` - Used with `yaxes` when the x and y axes are shared across columns and rows. Each entry should be an y axis id like "y", "y2", etc., or "" to not put a y axis in that row. Entries other than "" must be unique. Ignored if `subplots` is present. If missing but `xaxes` is present, will generate consecutive IDs.
* `ygap::Float64` - Vertical space between grid cells, expressed as a fraction of the total height available to one cell. Defaults to 0.1 for coupled-axes grids and 0.3 for independent grids. Type: number between or equal to `0` and `1`
* `yside::String` - Sets where the y axis labels and titles go. "left" means the very left edge of the grid. "left plot" is the leftmost plot that each y axis is used in. "right" and "right plot" are similar. Type: enumerated , one of ( `"left"` | `"left plot"` | `"right plot"` | `"right"` ) | Default: `"left plot"`
"""
Base.@kwdef mutable struct PlotLayoutGrid
  columns::Union{Int,Nothing} = nothing # >= 1
  domain_x::Union{Vector{Float64},Nothing} = nothing # fraction, e.g [0, 1]
  domain_y::Union{Vector{Float64},Nothing} = nothing # fraction, e.g [0, 1]
  pattern::Union{String,Nothing} = nothing # "independent" | "coupled"
  roworder::Union{String,Nothing} = nothing # "top to bottom" | "bottom to top"
  rows::Union{Int,Nothing} = nothing # >= 1
  subplots::Union{Matrix{String},Nothing} = nothing
  xaxes::Union{Vector{String},Nothing} = nothing
  xgap::Union{Float64,Nothing} = nothing # [0.0, 1.0]
  xside::Union{String,Nothing} = nothing # "bottom" | "bottom plot" | "top plot" | "top"
  yaxes::Union{Vector{String},Nothing} = nothing
  ygap::Union{Float64,Nothing} = nothing # [0.0, 1.0]
  yside::Union{String,Nothing} = nothing # "bottom" | "bottom plot" | "top plot" | "top"
end

function Base.show(io::IO, lg::PlotLayoutGrid)
  output = "Layout Grid: \n"
  for f in fieldnames(typeof(lg))
    prop = getproperty(lg, f)
    if prop !== nothing
      output *= "$f = $prop \n"
    end
  end

  print(io, output)
end

function Base.Dict(lg::PlotLayoutGrid)
  trace = Dict{Symbol,Any}()

  if (lg.domain_x !== nothing) & (lg.domain_y !== nothing)
    trace[:domain] = Dict(
      :x => lg.domain_x,
      :y => lg.domain_y
    )
  elseif lg.domain_x !== nothing
    trace[:domain] = Dict(
      :x => lg.domain_x
    )
  elseif lg.domain_y !== nothing
    trace[:domain] = Dict(
      :y => lg.domain_y
    )
  end

  optionals!(trace, lg, [:columns, :domain_x, :domain_y, :pattern, :roworder,
               :rows, :subplots, :xaxes, :xgap, :xside, :yaxes, :ygap, :yside])

end

#===#
"""
      GeoProjection()

----------
# Examples
----------

```
julia>
```

-----------
# Properties
-----------
* `distance::Float64` - For satellite projection type only. Sets the distance from the center of the sphere to the point of view as a proportion of the sphere’s radius.  Type: number greater than or equal to `1.001` | Default: `2`
* `parallels::Vector{Float64}` - For conic projection types only. Sets the parallels (tangent, secant) where the cone intersects the sphere.
* `rotation::Protation` - Check Protation struct for more details
* `scale::Float64` - Zooms in or out on the map view. A scale of "1" corresponds to the largest zoom level that fits the map's lon and lat ranges. number greater than or equal to `0` | Default: `1`
* `tilt::Float64` - For satellite projection type only. Sets the tilt angle of perspective projection. Type: `number` | Default: `0`
* `type::String` - Sets the projection type. Type: enumerated , one of ( `"albers"` | `"albers usa"` | `"azimuthal equal area"` | `"azimuthal equidistant"` | `"conic equal area"` | `"conic conformal"` | `"conic equidistant"` | `"equidistant conic"` | `"gnomonic"` | `"mercator"` | `"natural earth"` | `"orthographic"` | `"stereographic"` | `"transverse mercator"` )
"""
Base.@kwdef mutable struct GeoProjection
  distance::Union{Float64,Nothing} = nothing
  parallels::Union{Vector{Float64},Nothing} = nothing
  rotation::Union{Protation, Nothing} = nothing
  scale::Union{Float64,Nothing} = nothing
  tilt::Union{Float64,Nothing} = nothing
  type::Union{String,Nothing} = nothing
end

function Base.show(io::IO, proj::GeoProjection)
  output = "Geo Layout Projection: \n"
  for f in fieldnames(typeof(proj))
    prop = getproperty(proj, f)
    if prop !== nothing
      output *= "$f = $prop \n"
    end
  end

  print(io, output)
end

function Base.Dict(proj::GeoProjection)
  trace = Dict{Symbol, Any}()

  optionals!(trace, proj, [:distance, :parallels, :rotation, :scale, :tilt, :type])
end

function Stipple.render(proj::GeoProjection, fieldname::Union{Symbol,Nothing} = nothing)
  Dict(proj)
end

"""
    PlotLayoutGeo()

----------
# Examples
----------

```
julia>
```

-----------
# Properties
-----------
* `bgcolor::String` - Set the background color of the map.  Type: `color` | Default: `"#fff"`
* `center::Mcenter` - Check Mcenter documentation for details.
* `coastlinecolor::String` - Set the coastline color.  Type: `color` | Default: `"#444"`
* `coastlinewidth::Int` - Set the coastline width.  Type: `number` | Default: `1`
* `countrywidth::Int` - Sets line color of the country boundaries. Type: number greater than or equal to `0` | Default: `1`
* `fitbounds::Bool` - Determines if this subplot's view settings are auto-computed to fit trace data. On scoped maps, setting `fitbounds` leads to `center.lon` and `center.lat` getting auto-filled. On maps with a non-clipped projection, setting `fitbounds` leads to `center.lon`, `center.lat`, and `projection.rotation.lon` getting auto-filled. On maps with a clipped projection, setting `fitbounds` leads to `center.lon`, `center.lat`, `projection.rotation.lon`, `projection.rotation.lat`, `lonaxis.range` and `lonaxis.range` getting auto-filled. If "locations", only the trace's visible locations are considered in the `fitbounds` computations. If "geojson", the entire trace input `geojson` (if provided) is considered in the `fitbounds` computations, Defaults to "false". Type: enumerated , one of ( false | "locations" | "geojson" )
* `framecolor::String` - Set the frame color.  Type: `color` | Default: `"#444"`
* `framewidth::Int` - Sets the stroke width (in px) of the frame. Type: number greater than or equal to `0` | Default: `1`
* `lakecolor::String` - Set the color of the lakes.  Type: `color` | Default: `"#3399FF"`
* `landcolor::String` - Sets the land mass color. Type: `color` | Default: `"#F0DC82"`
* `lataxis::PlotLayoutAxis` - Check PlotLayoutAxis documentation for details.
* `lonaxis::PlotLayoutAxis` - Check PlotLayoutAxis documentation for details.
* `oceancolor::String` - Sets the ocean color. Type: `color` | Default: `"#3399FF"`
* `geoprojection::GeoProjection` - Check GeoProjection documentation for details.
* `resolution::String` - Sets the resolution of the base layers. The values have units of km/mm e.g. 110 corresponds to a scale ratio of `1:110,000,000`. Type: enumerated , one of ( `"110"` | `"50"` ) | Default: `"110"`
* `rivercolor::String` - Sets color of the rivers. Type: `color` | Default: `"#3399FF"`
* `riverwidth::Int` - Sets the stroke width (in px) of the rivers. Type: number greater than or equal to `0` | Default: `1`
* `scope::String` - Sets the scope of the map. Type: enumerated , one of ( `"world"` | `"usa"` | `"europe"` | `"asia"` | `"africa"` | `"north america"` | `"south america"` ) | Default: `"world"`
* `showcoastlines::Bool` - Sets whether or not the coastlines are drawn.
* `showcountries::Bool` - Sets whether or not country boundaries are drawn.
* `showframe::Bool` - Sets whether or not a frame is drawn around the map.
* `showlakes::Bool` - Sets whether or not lakes are drawn.
* `showland::Bool` - Sets whether or not land masses are filled in color.
* `showocean::Bool` - Sets whether or not oceans are filled in color.
* `showrivers::Bool` - Sets whether or not rivers are drawn.
* `showsubunits::Bool` - Sets whether or not boundaries of subunits within countries (e.g. states, provinces) are drawn.
* `subunitcolor::String` - Sets the color of the subunits boundaries. Type: `color` | Default: `"#444"`
* `subunitwidth::Int` - Sets the stroke width (in px) of the subunits boundaries. Type: number greater than or equal to `0` | Default: `1`
* `uirevision::Union{String,Int}` - Controls persistence of user-driven changes in the view (projection and center). Defaults to `layout.uirevision`.  Type: number or categorical coordinate string
* `visible::Bool` - Sets the default visibility of the base layers. Default: `true`
"""
Base.@kwdef mutable struct PlotLayoutGeo
  bgcolor::Union{String, Nothing} = nothing # ""
  center::Union{Mcenter, Nothing} = nothing # MCenter(0, 0)
  coastlinecolor::Union{String, Nothing} = nothing # ""
  coastlinewidth::Union{Int, Nothing} = nothing # 1
  countrycolor::Union{String, Nothing} = nothing # ""
  countrywidth::Union{Int, Nothing} = nothing # 1
  fitbounds::Union{Bool, Nothing} = nothing # false
  framecolor::Union{String, Nothing} = nothing # ""
  framewidth::Union{Int, Nothing} = nothing # 0
  lakecolor::Union{String, Nothing} = nothing # ""
  landcolor::Union{String, Nothing} = nothing # ""
  lataxis::Union{PlotLayoutAxis,Nothing} = nothing
  lonaxis::Union{PlotLayoutAxis,Nothing} = nothing
  oceancolor::Union{String, Nothing} = nothing # ""
  geoprojection::Union{GeoProjection, Nothing} = nothing
  resolution::Union{String, Nothing} = nothing # 50
  rivercolor::Union{String, Nothing} = nothing # ""
  riverwidth::Union{Int, Nothing} = nothing # 1
  scope::Union{String, Nothing} = nothing # "world"
  showcoastlines::Union{Bool, Nothing} = nothing # true
  showcountries::Union{Bool, Nothing} = nothing # true
  showframe::Union{Bool, Nothing} = nothing # false
  showlakes::Union{Bool, Nothing} = nothing # true
  showland::Union{Bool, Nothing} = nothing # true
  showocean::Union{Bool, Nothing} = nothing # true
  showrivers::Union{Bool, Nothing} = nothing # true
  showsubunits::Union{Bool, Nothing} = nothing # true
  subunitcolor::Union{String, Nothing} = nothing # ""
  subunitwidth::Union{Int, Nothing} = nothing # 1
  uirevision::Union{Int, String, Nothing} = nothing # "number or categorical coordinate string
  visible::Union{Bool, Nothing} = nothing # true
end

function Base.show(io::IO, geo::PlotLayoutGeo)
  output = "Layout Geo: \n"
  for f in fieldnames(typeof(geo))
    prop = getproperty(geo, f)
    if prop !== nothing
      output *= "$f = $prop \n"
    end
  end

  print(io, output)
end

function Base.Dict(geo::PlotLayoutGeo)
  trace = Dict{Symbol, Any}()

  optionals!(trace, geo, [
    :bgcolor, :center, :coastlinecolor, :coastlinewidth, :countrycolor, :countrywidth,
    :fitbounds, :framecolor, :framewidth, :lakecolor, :landcolor, :oceancolor, :geoprojection,
    :resolution, :rivercolor, :riverwidth, :scope, :showcoastlines, :showcountries, :showframe,
    :showlakes, :showland, :showocean, :showrivers, :showsubunits, :subunitcolor, :subunitwidth,
    :uirevision, :visible])
end

function Stipple.render(geo::PlotLayoutGeo, fieldname::Union{Symbol,Nothing} = nothing)
  Dict(geo)
end

#===#

Base.@kwdef mutable struct PlotLayoutMapbox
  style::Union{String, Nothing} = nothing # "open-street-map"
  zoom::Union{Float64, Nothing} = nothing # 0
  center::Union{Mcenter, Nothing} = nothing # MCenter(0, 0)
end

function Base.show(io::IO, mapbox::PlotLayoutMapbox)
  output = "Layout Geo: \n"
  for f in fieldnames(typeof(mapbox))
    prop = getproperty(mapbox, f)
    if prop !== nothing
      output *= "$f = $prop \n"
    end
  end

  print(io, output)
end

function Base.Dict(mapbox::PlotLayoutMapbox)
  trace = Dict{Symbol, Any}()

  optionals!(trace, geo, [:style, :zoom, :center])
end

function Stipple.render(mapbox::PlotLayoutMapbox, fieldname::Union{Symbol,Nothing} = nothing)
  Dict(map)
end

#===#

Base.@kwdef mutable struct PlotLayout
  title::Union{PlotLayoutTitle,Nothing} = nothing
  xaxis::Union{Vector{PlotLayoutAxis},Nothing} = nothing
  yaxis::Union{Vector{PlotLayoutAxis},Nothing} = nothing

  showlegend::Union{Bool,Nothing} = nothing # true
  legend::Union{PlotLayoutLegend,Nothing} = nothing
  annotations::Union{Vector{PlotAnnotation},Nothing} = nothing
  geo::Union{PlotLayoutGeo,Nothing} = nothing
  grid::Union{PlotLayoutGrid,Nothing} = nothing
  mapbox::Union{PlotLayoutMapbox,Nothing} = nothing
  margin_l::Union{Int,Nothing} = nothing # 80
  margin_r::Union{Int,Nothing} = nothing # 80
  margin_t::Union{Int,Nothing} = nothing # 100
  margin_b::Union{Int,Nothing} = nothing # 80
  margin_pad::Union{Int,Nothing} = nothing # 0
  margin_autoexpand::Union{Bool,Nothing} = nothing # true
  autosize::Union{Bool,Nothing} = nothing # true
  width::Union{Int,String,Nothing} = nothing # 700
  height::Union{Int,String,Nothing} = nothing # 450
  font::Union{Font,Nothing} = nothing
  uniformtext_mode::Union{String,Bool,Nothing} = nothing # false
  uniformtext_minsize::Union{Int,Nothing} = nothing # 0
  separators::Union{String,Nothing} = nothing # ".,"
  paper_bgcolor::Union{String,Nothing} = nothing # "#fff"
  plot_bgcolor::Union{String,Nothing} = nothing # "#fff"

  # TODO: implement the following fields in function Stipple.render(pl::PlotLayout...
  autotypenumbers::String = "convert types"
  # TODO: colorscale settings
  colorway::Vector{String} = ["#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
                              "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"]
  modebar_orientation::String = LAYOUT_ORIENTATION_HORIZONTAL
  modebar_bgcolor::String = "transparent"
  modebar_color::String = ""
  modebar_activecolor::String = ""
  # TODO: modebar_uirevision::String = ""
  hovermode::Union{String,Bool} = "closest"
  clickmode::String = "event"
  dragmode::String = "zoom"
  selectdirection::String = "any"
  hoverdistance::Int = 20
  spikedistance::Int = 20
  hoverlabel_bgcolor::String = ""
  hoverlabel_bordercolor::String = ""
  hoverlabel_font::Font = Font()
  hoverlabel_align::String = LAYOUT_AUTO
  hoverlabel_namelength::Int = 15
  transition_duration::Int = 500
  transition_easing::String = "cubic-in-out"
  transition_ordering::String = "layout first"
  # TODO: datarevision
  # TODO: editrevision
  # TODO: selectionrevision
  # TODO: template
  # TODO: meta
  # TODO: computed

  calendar::String = "gregorian"
  newshape_line_color::String = ""
  newshape_line_width::Int = 4
  newshape_line_dash::String = "solid"
  newshape_fillcolor::String = "rgba(0,0,0,0)"
  newshape_fillrule::String = "evenodd"
  newshape_opacity::Float64 = 1.0
  newshape_layer::String = LAYOUT_ABOVE
  newshape_drawdirection::String = "diagonal"
  activeshape_fillcolor::String = "rgb(255,0,255)"
  activeshape_opacity::Float64 = 0.5
  # TODO: hidesources
  barmode::Union{String,Nothing} = nothing # LAYOUT_GROUP
  barnorm::Union{String,Nothing} = nothing
  bargap::Union{Float64,Nothing} = nothing # 0.5
  bargroupgap::Union{Float64,Nothing} = nothing # 0
  # TODO: hiddenlabels
  # TODO: piecolorway
  extendpiecolors::Bool = true
  boxmode::String = LAYOUT_OVERLAY
  boxgap::Float64 = 0.3
  boxgroupgap::Float64 = 0.3
  violinmode::String = LAYOUT_OVERLAY
  violingap::Float64 = 0.3
  violingroupgap::Float64 = 0.3
  waterfallmode::String = LAYOUT_GROUP
  waterfallgap::Float64 = 0.3
  waterfallgroupgap::Float64 = 0.0
  funnelmode::String = LAYOUT_STACK
  funnelgap::Float64 = 0.0
  funnelgroupgap::Float64 = 0.0
  # TODO: funnelareacolorway
  extendfunnelareacolors::Bool = true
  # TODO: sunburstcolorway
  extendsunburstcolors::Bool = true
  # TODO: treemapcolorway
  extendtreemapcolors::Bool = true
end

function Base.show(io::IO, l::PlotLayout)
  default = PlotLayout()
  output = "layout: \n"
  for f in fieldnames(typeof(l))
    prop = getproperty(l, f)
    if prop != getproperty(default, f)
      output *= "$f = $prop \n"
    end
  end

  print(io, output)
end

function Base.Dict(pl::PlotLayout, fieldname::Union{Symbol,Nothing} = nothing)
  layout = Dict{Symbol, Any}()

  if pl.font !== nothing
    layout[:font] = Dict{Symbol, Any}(
      :family => pl.font.family,
      :size => pl.font.size,
      :color => pl.font.color
    )
  end

  d1 = Dict{Symbol, Any}()
  (pl.margin_l !== nothing) && (d1[:l] = pl.margin_l)
  (pl.margin_r !== nothing) && (d1[:r] = pl.margin_r)
  (pl.margin_t !== nothing) && (d1[:t] = pl.margin_t)
  (pl.margin_b !== nothing) && (d1[:b] = pl.margin_b)
  (pl.margin_pad !== nothing) && (d1[:pad] = pl.margin_pad)
  (pl.margin_autoexpand !== nothing) && (d1[:autoexpand] = pl.margin_autoexpand)
  (length(d1) > 0) && (layout[:margin] = d1)

  d2 = Dict{Symbol, Any}()
  (pl.uniformtext_mode !== nothing) && (d2[:mode] = pl.uniformtext_mode)
  (pl.uniformtext_minsize !== nothing) && (d2[:minsize] = pl.uniformtext_minsize)
  (length(d2) > 0) && (layout[:uniformtext] = d2)

  (pl.title !== nothing) && (layout[:title] = Dict(pl.title))
  (pl.legend !== nothing) && (layout[:legend] = Dict(pl.legend))
  (pl.annotations !== nothing) && (layout[:annotations] = Dict.(pl.annotations))
  (pl.grid !== nothing) && (layout[:grid] = Dict(pl.grid))

  optionals!(layout, pl, [ :showlegend, :autosize, :separators, :paper_bgcolor, :plot_bgcolor,
    :width, :height, :barmode, :barnorm, :bargap, :bargroupgap, :geo, :mapbox
  ])


  if pl.xaxis !== nothing
    for d in Dict.(pl.xaxis)
      merge!(layout, d)
    end
  end

  if pl.yaxis !== nothing
    for d in Dict.(pl.yaxis)
      merge!(layout, d)
    end
  end

  layout
end

function Stipple.render(pl::PlotLayout, fieldname::Union{Symbol,Nothing} = nothing)
  Dict(pl)
end

function Stipple.render(pl::Vector{PlotLayout}, fieldname::Union{Symbol,Nothing} = nothing)
  Dict.(pl)
end

end