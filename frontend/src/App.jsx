import React from 'react'
import Navbar from '../Pages/Navbar'
import Hero from '../Pages/Hero'

const App = () => {
  return (
    <div className='flex justify-center items-center flex-col h-screen w-4/5 mx-auto'>
      <Navbar/> 
      <Hero/>
    </div>
  )
}

export default App
