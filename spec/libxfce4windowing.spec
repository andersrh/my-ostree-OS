Name:           libxfce4windowing
Version:        4.20.0
Release:        1%{?dist}
Summary:        Windowing concept abstraction library for Xfce

License:        LGPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/libxfce4windowing/4.20/libxfce4windowing-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  glib2-devel
BuildRequires:  gtk3-devel
BuildRequires:  libWnck3-devel
BuildRequires:  libX11-devel
BuildRequires:  libXrandr-devel
BuildRequires:  libdisplay-info-devel
BuildRequires:  wayland-devel
BuildRequires:  wayland-protocols-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool

%description
Libxfce4windowing is an abstraction library that attempts to handle
windowing concepts (screens, desktops, windows) in a windowing-system
independent way.

%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description    devel
Development files for %{name}.

%prep
%autosetup

%build
%configure \
    --disable-static \
    --enable-x11 \
    --enable-wayland
%make_build

%install
%make_install
find %{buildroot} -name '*.la' -delete

%find_lang libxfce4windowing

%files -f libxfce4windowing.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_libdir}/libxfce4windowing-0.so.*
%{_libdir}/libxfce4windowing-gtk3-0.so.*

%files devel
%{_includedir}/xfce4/libxfce4windowing/
%{_includedir}/xfce4/libxfce4windowing-gtk3/
%{_libdir}/libxfce4windowing-0.so
%{_libdir}/libxfce4windowing-gtk3-0.so
%{_libdir}/pkgconfig/libxfce4windowing-0.pc
%{_libdir}/pkgconfig/libxfce4windowing-gtk3-0.pc

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
- Include X11 and Wayland support
