import React from 'react'


const Navbar = () => {
  return (
    <div className='flex justify-between p-4 flex-col w-full gap-4 '>

      <div className="logo">BenefitEase</div>

      <div className="hello-user flex gap-2">
        <img src="/Database.png" alt="" className='h-5' />
        <h2>Hello Admin!</h2>
      </div>    

      <div className="nav flex bg-[#18181B] rounded-2xl w-full items-center justify-between px-4 gap-2">
        <a href="#">DashBoard</a>
        <a href="#">Employees</a>
        <a href="#">Leaves/Off-Day</a>
        <a href="#">Payroll</a>
        <a href="#">Projects</a>
        <a href="#">Tasks</a>
        </div>  

    </div>
  )
}

export default Navbar
