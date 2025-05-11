import React from 'react'

const Button = ({image, href, name}) => {
  return (
    <a href={href} className='flex items-center rounded-2xl w-auto px-4 bg-[#18181B] justify-between'>
        <img src={image} alt="" />
        {name}
    </a>
  )
}

export default Button
