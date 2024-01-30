data = [
  {
    name: '1',
    slug: 'f26497ec0e237ab6',
    children: [
      {
        name: '1_1',
        slug: '3de9e298f14cb4e9',
      },
      {
        name: '1_2',
        slug: 'ab5beaea7a1e7c8e'
      },
      {
        name: '1_3',
        slug: 'ddfefdb0cc1c89ed'
      },
    ],
  },
  {
    name: '2',
    slug: 'ecc899ad0a5b8ad9',
    children: [
      {
        name: '2_1',
        slug: '0a51a39bfedad217'
      },
      {
        name: '2_2',
        slug: '174ab9cec504a5f4'
      },
      {
        name: '2_3',
        slug: 'a5d497feef5dd538'
      },
    ],
  },
  {
    name: '3',
    slug: '4e6ad97f4214f33a',
    children: [
      {
        name: '3_1',
        slug: 'a287dbd4419a6e9c'
      },
      {
        name: '3_2',
        slug: '99f6ee94aa3d4685'
      },
      {
        name: '3_3',
        slug: 'dcf37f1db9ffb376'
      },
    ],
  }
]

def create_category_with_children(parent, children_data)
  children_data.each do |child_data|
    identifier = child_data.delete(:slug)
    children = child_data.delete(:children)
    category = parent.children.find_or_initialize_by(slug: identifier)
    category.assign_attributes(child_data)
    category.save
    create_category_with_children(category, children || [])
  end
end

data.each do |args|
  identifier = args.delete(:slug)
  children = args.delete(:children)
  category = Category.find_or_initialize_by(slug: identifier)
  category.assign_attributes(args)
  category.save
  create_category_with_children(category, children || [])
end
