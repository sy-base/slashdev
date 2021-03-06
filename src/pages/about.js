import React from "react"
import { graphql } from "gatsby"
import Layout from "../components/layout"
import SEO from "../components/seo"
import { FaCheckCircle } from "react-icons/fa"
import "./index.css"

import Sidebar from "../components/sidebar/Sidebar"
import TechTag from "../components/tags/TechTag"

const AboutPage = (props) => {
    const labels = props.data.site.siteMetadata.labels
    const aboutTags = ["apacheweb", "nginx", "oracle", "mysql", "postgresql", "c", "python", "bash", "netapp", "gatsby", "nodejs", "docker", "cisco", "dell", "vmware", "redhatlinux", "archlinux", "linux", "openbsd", "windows", "aws", "gcloud", "azure"]
    const tags = {}
    labels.forEach(label => {
        aboutTags.forEach(tag => {
            if (tag === label.tag) {
                tags[tag] = label.name
            }
        })
    })

    return (
        <Layout>
            <SEO title="About" />
            <div className="post-page-main">
                <div className="sidebar px-4 py-2">
                    <Sidebar />
                </div>

                <div className="post-main">
                    <SEO title="About" />
                    <div className="mt-3">
                        <h2 className="heading">About</h2>
                        <p><i>I am a self-taught Linux systems engineer with over 20 years of experience in IT. I started my career in the late 1990s working for a startup internet service provider and from the very beginning I had a passion for using and modifying software to achieve my goals. My experience with development started when I was a teenager teaching myself QBasic on DOS 6, and from that point on I continued to mix development with my roles in operations and engineering.
                            </i></p>
                        <br />
                        <h4>Current Interests</h4>
                            <div className="ml-5">
                                <TechTag tag="gatsby" tech="Gatsby" name={tags["gatsby"]} size={20} color="rebeccapurple" />
                                <TechTag tag="nodejs" tech="NodeJS" name={tags["nodejs"]} size={20} color="lightgreen" />
                                <TechTag tag="gcloud" tech="Google Cloud" name={tags["gcloud"]} size={20} color="#4285F4" />
                                <TechTag tag="docker" tech="Containers" name={tags["docker"]} size={20} color="#2496ED" />
                                <TechTag tag="redhatlinux" tech="Red Hat Linux 8" name={tags["redhatlinux"]} size={20} color="#EE0000" />
                            </div><br></br>
                        <h4>Technical experience</h4>
                        <div>
                            <span className="text-success d-inline-block" title="os">
                                <FaCheckCircle size={26} style={{ color: "success" }} />
                            </span>
                            <p className="d-inline-block ml-3 w-75 align-top">Operating Systems</p>
                            <div className="ml-5">
                                <TechTag tag="vmware" tech="VMware" name={tags["vmware"]} size={20} color="#607078" />
                                <TechTag tag="redhatlinux" tech="Red Hat Linux 6/7/8" name={tags["redhatlinux"]} size={20} color="#EE0000" />
                                <TechTag tag="archlinux" tech="Arch Linux" name={tags["archlinux"]} size={20} color="#1793D1" />
                                <TechTag tag="openbsd" tech="OpenBSD" name={tags["openbsd"]} size={20} color="#F2CA30" />
                                <TechTag tag="windows" tech="Microsoft Windows" name={tags["windows"]} size={20} color="#666666" />
                            </div>  
                        </div>
                        <div>
                            <span className="text-success d-inline-block" title="cloud">
                                <FaCheckCircle size={26} style={{ color: "success" }} />
                            </span>
                            <p className="d-inline-block ml-3 w-75 align-top">Cloud</p>
                            <div className="ml-5">
                                <TechTag tag="aws" tech="AWS" name={tags["aws"]} size={20} color="#FC4C02" />
                                <TechTag tag="gcloud" tech="Google Cloud" name={tags["gcloud"]} size={20} color="#4285F4" />
                                <TechTag tag="azure" tech="Azure" name={tags["azure"]} size={20} color="#0089D6" />
                            </div>  
                        </div>
                        <div>
                            <span className="text-success d-inline-block" title="language">
                                <FaCheckCircle size={26} style={{ color: "success" }} />
                            </span>
                            <p className="d-inline-block ml-3 w-75 align-top">Languages</p>
                            <div className="ml-5">
                                <TechTag tag="c" tech="C Language" name={tags["c"]} size={20} color="#A8B9CC" />
                                <TechTag tag="python" tech="Python" name={tags["python"]} size={20} color="deepskyblue" />
                                <TechTag tag="bash" tech="GNU Bash" name={tags["bash"]} size={20} color="#4EAA25" />
                            </div>  
                        </div>

                        <div>
                            <span className="text-success d-inline-block" title="applications">
                                <FaCheckCircle size={26} style={{ color: "success" }} />
                            </span>
                            <p className="d-inline-block ml-3 w-75 align-top">Applications</p>
                            <div className="ml-5">
                            <TechTag tag="apacheweb" tech="Apache Webserver" name={tags["apacheweb"]} size={20} color="#D22128" />
                            <TechTag tag="nginx" tech="NGINX" name={tags["nginx"]} size={20} color="#269539" />
                            <TechTag tag="oracle" tech="Oracle Weblogic" name={tags["oracle"]} size={20} color="#F80000" />
                            <TechTag tag="mysql" tech="MySQL" name={tags["mysql"]} size={20} color="#4479A1" />
                            <TechTag tag="postgresql" tech="PostgreSQL" name={tags["postgresql"]} size={20} color="#336791" />
                            </div>  
                        </div>
                        <div>
                        <span className="text-success d-inline-block" title="os">
                                <FaCheckCircle size={26} style={{ color: "success" }} />
                            </span>
                            <p className="d-inline-block ml-3 w-75 align-top">Hardware</p>
                            <div className="ml-5">
                                <TechTag tag="cisco" tech="Cisco UCS" name={tags["cisco"]} size={20} color="#1BA0D7" />
                                <TechTag tag="dell" tech="Dell Servers" name={tags["dell"]} size={20} color="#007DB8" />
                            </div>  
                        </div>
                        <div>
                            <span className="text-success d-inline-block" title="storage">
                                <FaCheckCircle size={26} style={{ color: "success" }} />
                            </span>
                            <p className="d-inline-block ml-3 w-75 align-top">Storage</p>
                            <div className="ml-5">
                                <TechTag tag="netapp" tech="NetApp" name={tags["netapp"]} size={20} color="#0067C5" />
                            </div>  
                        </div>
                        <div>
                            <span className="text-success d-inline-block" title="networking">
                                <FaCheckCircle size={26} style={{ color: "success" }} />
                            </span>
                            <p className="d-inline-block ml-3 w-75 align-top">Networking</p>
                            <div className="ml-5">
                                <TechTag tag="cisco" tech="Cisco Switches" name={tags["cisco"]} size={20} color="#1BA0D7" />
                            </div>  
                        </div>
                        <br></br>
                        <h4>Certifications (former and current)</h4>
                        <div>
                            <span className="text-success d-inline-block" title="awscda">
                                <FaCheckCircle size={26} style={{ color: "success" }} />
                            </span>
                            <p className="d-inline-block ml-3 w-75 align-top">AWS Cerfitified Developer Associate</p>
                        </div>
                        <div>
                            <span className="text-success d-inline-block" title="awscsaa">
                                <FaCheckCircle size={26} style={{ color: "success" }} />
                            </span>
                            <p className="d-inline-block ml-3 w-75 align-top">AWS Cerfitified Solution Architect Associate</p>
                        </div>
                        <div>
                            <span className="text-success d-inline-block" title="awscsa">
                                <FaCheckCircle size={26} style={{ color: "success" }} />
                            </span>
                            <p className="d-inline-block ml-3 w-75 align-top">AWS Cerfitified SysOps Associate</p>
                        </div>
                        <div>
                            <span className="text-success d-inline-block" title="rhce">
                                <FaCheckCircle size={26} style={{ color: "success" }} />
                            </span>
                            <p className="d-inline-block ml-3 w-75 align-top">Red Hat Certified Engineer</p>
                        </div>

                    </div>
                </div>
            </div>
        </Layout>
    )
}

export const pageQuery = graphql`
    query aboutQuery {
        site {
            siteMetadata {
                labels {
                    tag
                    tech 
                    name 
                    size 
                    color
                }
            }
        }
    }
`

export default AboutPage

