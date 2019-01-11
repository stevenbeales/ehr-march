module ApplicationHelper
  def week_days
    [
        { abbr: 'M',  name: 'monday'    },
        { abbr: 'T',  name: 'tuesday'   },
        { abbr: 'W',  name: 'wednesday' },
        { abbr: 'Th', name: 'thursday'  },
        { abbr: 'F',  name: 'friday'    },
        { abbr: 'Sa', name: 'saturday'  },
        { abbr: 'Su', name: 'sunday'    },
    ]
  end

  def paginate(collection, params= {})
    will_paginate collection, params.merge(:renderer => RemoteLinkPaginationHelper::LinkRenderer)
  end
end
